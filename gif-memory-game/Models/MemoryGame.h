//
//  MemoryGame.h
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryTile.h"

@interface MemoryGame : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSMutableArray *tiles;
@property (nonatomic, assign, readonly) NSUInteger numberOfTurns;

- (void)newGameWithCompletion:(void (^)(BOOL success))completion;
- (void)saveCurrentGame;
- (BOOL)savedGameExists;

- (void)handleTurn:(MemoryTile *)tile;
+ (instancetype)sharedInstance;
@end
