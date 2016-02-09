//
//  TwitterNetworkingModel.m
//  gif-memory-game
//
//  Created by Jon on 2/8/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "TwitterNetworkingModel.h"
#import "Secrets.h"
#import <STTwitter/STTwitter.h>

@implementation TwitterNetworkingModel

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)fetchTrends:(void (^)(NSArray *trends))success failure:(void (^)(NSError *))failure
{
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_CONSUMER_KEY
                                                            consumerSecret:TWITTER_CONSUMER_SECRET
                             ];
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        
        [twitter getTrendsForWOEID:@"2459115" excludeHashtags:@1 successBlock:^(NSDate *asOf, NSDate *createdAt, NSArray *locations, NSArray *trends) {
            NSMutableArray *allTrends = [[NSMutableArray alloc] init];
            for (NSDictionary *trendDictionary in trends) {
                NSString *trend = trendDictionary[@"name"];
                [allTrends addObject:trend];
            }
            success(allTrends);
        } errorBlock:^(NSError *error) {
            failure(error);
        }];
        
    } errorBlock:^(NSError *error) {
        failure(error);
    }];
}
@end
