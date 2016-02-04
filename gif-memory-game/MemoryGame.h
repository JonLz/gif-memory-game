//
//  MemoryGame.h
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryTile.h"

@interface MemoryGame : NSObject
- (void)newGameWithCompletion:(void (^)(BOOL success))completion;

- (void)handleTurn:(MemoryTile *)tile;

+ (instancetype)sharedInstance;
@end
