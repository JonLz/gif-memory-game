//
//  MemoryTileView.h
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoryTile.h"

@interface MemoryTileView : UIControl

- (instancetype)initWithTile:(MemoryTile *)tile;
- (void)flipTile;
@end
