//
//  MemoryGame.m
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "MemoryGame.h"
#import "GiphyNetworkingModel.h"
#import "NSMutableArray+Shuffle.h"

@interface MemoryGame ()
@property (nonatomic, strong) NSMutableArray *tiles;
@property (nonatomic, strong) NSMutableArray *selectedTiles;
@property (nonatomic, assign) NSUInteger numberOfTurns;
@property (nonatomic, assign) BOOL readyForNextTurn;
@property (nonatomic, assign) BOOL gameInProgress;
@end

@implementation MemoryGame
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _tiles = [[NSMutableArray alloc] init];
    _selectedTiles = [[NSMutableArray alloc] init];
    _readyForNextTurn = YES;
    _gameInProgress = YES;
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) return nil;
    
    _tiles = [aDecoder decodeObjectForKey:@"tiles"];
    _selectedTiles = [aDecoder decodeObjectForKey:@"selectedTiles"];
    _numberOfTurns = [aDecoder decodeIntegerForKey:@"numberOfTurns"];
    _readyForNextTurn = [aDecoder decodeBoolForKey:@"readyForNextTurn"];
    _gameInProgress = [aDecoder decodeBoolForKey:@"gameInProgress"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tiles forKey:@"tiles"];
    [aCoder encodeObject:self.selectedTiles forKey:@"selectedTiles"];
    [aCoder encodeInteger:self.numberOfTurns forKey:@"numberOfTurns"];
    [aCoder encodeBool:self.readyForNextTurn forKey:@"readyForNextTurn"];
    [aCoder encodeBool:self.gameInProgress forKey:@"gameInProgress"];
}


+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        
        // Try to load the saved game
        // Or else default to a new game
        
        NSData *savedGameData = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.memory.game"];
        
        if (savedGameData) {
            sharedInstance = [NSKeyedUnarchiver unarchiveObjectWithData:savedGameData];
        } else {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

- (void)newGameWithCompletion:(void (^)(BOOL success))completion
{
    [self.tiles removeAllObjects];
    [self.selectedTiles removeAllObjects];
    self.numberOfTurns = 0;
    self.gameInProgress = YES;
    
    [self generateTilesWithCompletion:^(BOOL success) {
        completion(success);
    }];
}

- (void)saveCurrentGame
{
    if (self.gameInProgress) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *gameData = [NSKeyedArchiver archivedDataWithRootObject:self];
        [defaults setObject:gameData forKey:@"com.memory.game"];
        [defaults synchronize];
    }
}

- (BOOL)savedGameExists
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.memory.game"] != nil;
}

- (void)generateTilesWithCompletion:(void (^)(BOOL success))completion
{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *keyword = [def objectForKey:@"com.memory.keyword"];
   
    GiphyNetworkingModel *sharedGiphyAPI = [GiphyNetworkingModel sharedInstance];
    
    if (keyword) {
        [sharedGiphyAPI fetchGiphyImageDataForSearchTerm:keyword success:^(NSArray *imageData) {
            [self loadTilesWithImages:imageData];
            completion(YES);
            
        } failure:^(NSError *error) {
            completion(NO);
        }];
        
    } else {
        [sharedGiphyAPI fetchTrendingGiphyImageData:^(NSArray *imageData) {
            [self loadTilesWithImages:imageData];
            completion(YES);
            
        } failure:^(NSError *error) {
            completion(NO);
            
        }];
    }
    
}

- (void)loadTilesWithImages:(NSArray *)imageData
{
    for (NSDictionary *result in imageData) {
        MemoryTile *tile = [[MemoryTile alloc] initWithDictionary:result];
        [self.tiles addObject:tile];
        
        MemoryTile *tileCopy = [[MemoryTile alloc] initWithDictionary:result];
        [self.tiles addObject:tileCopy];
    }
    
    [self.tiles shuffle];
}

- (void)handleTurn:(MemoryTile *)tile
{
    if (tile.visible || !self.readyForNextTurn) {
        return;
    }
    
    tile.visible = YES;
    [self.selectedTiles addObject:tile];
    
    if ([self.selectedTiles count] == 1) {
        return;
    }
  
    if (self.readyForNextTurn) {
        self.numberOfTurns++;
    }
    
    MemoryTile *firstTile = self.selectedTiles[0];
    MemoryTile *secondTile = self.selectedTiles[1];
    
    if ([firstTile.ID isEqualToString:secondTile.ID]) {
        [self.selectedTiles removeAllObjects];
    } else {
        self.readyForNextTurn = NO;
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            firstTile.visible = NO;
            secondTile.visible = NO;
            self.readyForNextTurn = YES;
        });
        
        [self.selectedTiles removeAllObjects];
    }
    
    BOOL winner = YES;
    for (MemoryTile *tile in self.tiles) {
        if (!tile.visible) {
            winner = NO;
        }
    }
    
    if (winner) {
        self.gameInProgress = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"com.memory.game"];
    }
    
    return;
    
    
}

@end
