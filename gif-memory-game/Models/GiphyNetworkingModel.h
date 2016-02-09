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
- (void)fetchTrendingGiphyImageData:(void (^)(NSArray *imageData))success failure:(void (^)(NSError *error))failure;
- (void)fetchGiphyImageDataForSearchTerm:(NSString *)searchTerm success:(void (^)(NSArray *imageData))success failure:(void (^)(NSError *error))failure;
@end
