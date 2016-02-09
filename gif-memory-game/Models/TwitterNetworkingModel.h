//
//  TwitterNetworkingModel.h
//  gif-memory-game
//
//  Created by Jon on 2/8/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterNetworkingModel : NSObject
- (void)fetchTrends:(void (^)(NSArray *trends))success failure:(void (^)(NSError *error))failure;
+ (instancetype)sharedInstance;
@end
