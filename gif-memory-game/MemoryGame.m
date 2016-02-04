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

@end

@implementation MemoryGame
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    _tiles = [[NSMutableArray alloc] init];
    _selectedTiles = [[NSMutableArray alloc] init];

    return self;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)newGameWithCompletion:(void (^)(BOOL success))completion
{
    [self.tiles removeAllObjects];
    [self.selectedTiles removeAllObjects];
    self.numberOfTurns = 0;
    [self generateTilesWithCompletion:^(BOOL success) {
        completion(YES);
    }];

}

- (void)generateTilesWithCompletion:(void (^)(BOOL success))completion
{
    GiphyNetworkingModel *sharedGiphyAPI = [GiphyNetworkingModel sharedInstance];
    [sharedGiphyAPI fetchGiphyImageData:^(NSArray *imageData) {
        
        for (NSDictionary *result in imageData) {
            MemoryTile *tile = [[MemoryTile alloc] initWithDictionary:result];
            [self.tiles addObject:tile];
            [self.tiles addObject:tile];
        }
        
        [self.tiles shuffle];
        completion(YES);
        
    } failure:^(NSError *error) {
        completion(NO);
        
    }];
}

- (void)handleTurn:(MemoryTile *)tile
{
    tile.visible = YES;
   [self.selectedTiles addObject:tile];
    
    if ([self.selectedTiles count] == 1) {
        return;
    }

    MemoryTile *firstTile = self.selectedTiles[0];
    MemoryTile *secondTile = self.selectedTiles[1];
    
    if (![firstTile.ID isEqualToString:secondTile.ID]) {
        for (MemoryTile *tile in self.selectedTiles) {
            tile.visible = NO;
        }
    }
    
    [self.selectedTiles removeAllObjects];
    
    BOOL winner = YES;
    for (MemoryTile *tile in self.tiles) {
        if (!tile.visible) {
            winner = NO;
        }
    }
    
    if (winner) {
        NSLog(@"You win");
    }
    
    return;
    
    
}
@end
