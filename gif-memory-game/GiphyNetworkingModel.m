//
//  GiphyNetworkingModel.m
//  gif-memory-game
//
//  Created by Jon on 2/3/16.
//  Copyright © 2016 Second Wind, LLC. All rights reserved.
//

#import "GiphyNetworkingModel.h"
#import <AFNetworking/AFNetworking.h>

@implementation GiphyNetworkingModel

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    
    [self stubsOn];
    
    return self;
}

+(instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)retrieveGifUrlsWithSuccess:(void (^)(NSArray *urls))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *url = @"http://api.giphy.com";
    
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *results = responseObject[@"data"];
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        
        for (NSDictionary *result in results) {
            NSString *fixedHeightImageURL = result[@"images"][@"fixed_height"][@"url"];
            [urls addObject:[NSURL URLWithString:fixedHeightImageURL]];
        }
        
        success(urls);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
        
    }];
}

-(void)stubsOn
{
    // Stubbed response for endpoint:
    // http://api.giphy.com/v1/gifs/trending?api_key=dc6zaTOxFJmzC&limit=24

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return YES;
    } withStubResponse:^OHHTTPStubsResponse * _Nonnull(NSURLRequest * _Nonnull request) {
        return [OHHTTPStubsResponse responseWithFileAtPath:[bundle pathForResource:@"GiphyResponse" ofType:@"json"] statusCode:200 headers:@{@"Content-Type":@"application/json"}];
    }];
}
@end
