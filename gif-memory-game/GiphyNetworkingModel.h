//
//  GiphyNetworkingModel.h
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface GiphyNetworkingModel : NSObject
+ (instancetype)sharedInstance;
- (void)retrieveGifUrlsWithSuccess:(void (^)(NSArray *urls))success failure:(void (^)(NSError *error))failure;

@end
