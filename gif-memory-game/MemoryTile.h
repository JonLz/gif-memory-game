//
//  MemoryTile.h
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemoryTile : NSObject
@property (nonatomic, strong) NSURL *smallStillURL;
@property (nonatomic, strong) NSURL *largeStillURL;
@property (nonatomic, strong) NSURL *smallAnimatedURL;
@property (nonatomic, strong) NSURL *largeAnimatedURL;
@property (nonatomic, strong) NSString *ID;

@property (nonatomic, assign) BOOL visible;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
