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

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _smallStillURL = [aDecoder decodeObjectForKey:@"smallStillURL"];
    _largeStillURL = [aDecoder decodeObjectForKey:@"largeStillURL"];
    _smallAnimatedURL = [aDecoder decodeObjectForKey:@"smallAnimatedURL"];
    _largeAnimatedURL = [aDecoder decodeObjectForKey:@"largeAnimatedURL"];
    _ID = [aDecoder decodeObjectForKey:@"id"];
    _visible = [aDecoder decodeBoolForKey:@"visible"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.smallStillURL forKey:@"smallStillURL"];
    [aCoder encodeObject:self.largeStillURL forKey:@"largeStillURL"];
    [aCoder encodeObject:self.smallAnimatedURL forKey:@"smallAnimatedURL"];
    [aCoder encodeObject:self.largeAnimatedURL forKey:@"largeAnimatedURL"];
    [aCoder encodeObject:self.ID forKey:@"id"];
    [aCoder encodeBool:self.visible forKey:@"visible"];
    
}

@end
