//
//  MemoryTile.m
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "MemoryTile.h"

@implementation MemoryTile
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (!self) return nil;
    
    _smallStillURL = dict[@"images"][@"fixed_height_still"][@"url"];
    _largeStillURL = dict[@"images"][@"downsized_still"][@"url"];
    _smallAnimatedURL = dict[@"images"][@"fixed_height"][@"url"];
    _largeAnimatedURL = dict[@"images"][@"downsized"][@"url"];
    _ID = dict[@"id"];
    
    _visible = NO;
    
    return self;
}
@end
