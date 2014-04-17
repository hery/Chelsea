//
//  FoursquareHTTPClient.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "FoursquareHTTPClient.h"

NSString * const foursquareAPIBaseURLString = @"https://api.foursquare.com/v2/";
NSString * const DATEVERIFIED = @"20140417";

@implementation FoursquareHTTPClient

+ (FoursquareHTTPClient *)sharedFoursquareHTTPClient
{
    static FoursquareHTTPClient *sharedFoursquareHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFoursquareHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:foursquareAPIBaseURLString]];
    });
    return sharedFoursquareHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        _authToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"foursquareAccessCode"];
    }
    return self;
}

// <Search>
- (void)performGETRequestForEndpointString:(NSString *)endpointString endpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant additionalParameters:(NSDictionary *)additionalParameters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:additionalParameters];
    [parameters setValue:_authToken forKey:@"oauth_token"];
    [parameters setValue:DATEVERIFIED forKey:@"v"];
    NSLog(@"Request parameter dictionary: %@", parameters);

    [self GET:endpointString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate foursquareHTTPClient:self didPerformRequestWithResponse:responseObject forEndpointConstant:endpointConstant];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate foursquareHTTPClient:self didFailWithError:error];
    }];
}

// <Check-In>
- (void)performPOSTRequestForEndpointString:(NSString *)endpointString endpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant additionalParameters:(NSDictionary *)additionalParameters
{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:additionalParameters];
    [parameters setValue:_authToken forKey:@"oauth_token"];
    [parameters setValue:DATEVERIFIED forKey:@"v"];
    NSLog(@"Request parameter dictionary: %@", parameters);

    [self POST:endpointString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate foursquareHTTPClient:self didPerformRequestWithResponse:responseObject forEndpointConstant:endpointConstant];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate foursquareHTTPClient:self didFailWithError:error];
    }];
}

@end
