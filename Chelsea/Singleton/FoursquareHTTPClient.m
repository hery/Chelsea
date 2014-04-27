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
    }
    return self;
}

// <Search>
- (void)performGETRequestForEndpointString:(NSString *)endpointString endpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant additionalParameters:(NSDictionary *)additionalParameters
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:additionalParameters];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fsAuthToken = [standardUserDefaults objectForKey:@"foursquareAccessCode"];
    
    NSLog(@"Auth token for request: %@", fsAuthToken);
    [parameters setValue:fsAuthToken forKey:@"oauth_token"];
    NSLog(@"Verified date for request: %@", DATEVERIFIED);
    [parameters setValue:DATEVERIFIED forKey:@"v"];
    NSDictionary *immutableParameters = [[NSDictionary alloc] initWithDictionary:parameters];
    NSLog(@"Request parameter dictionary: %@", immutableParameters);

    [self GET:endpointString parameters:immutableParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate foursquareHTTPClient:self didPerformRequestWithResponse:responseObject forEndpointConstant:endpointConstant];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate foursquareHTTPClient:self didFailWithError:error];
    }];
}

// <Check-In>
- (void)performPOSTRequestForEndpointString:(NSString *)endpointString endpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant additionalParameters:(NSDictionary *)additionalParameters
{
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fsAuthToken = [standardUserDefaults objectForKey:@"foursquareAccessCode"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:additionalParameters];
    NSLog(@"Auth token for request: %@", fsAuthToken);
    [parameters setValue:fsAuthToken forKey:@"oauth_token"];
    [parameters setValue:DATEVERIFIED forKey:@"v"];
    NSDictionary *immutableParameters = [[NSDictionary alloc] initWithDictionary:parameters];
    NSLog(@"Request parameter dictionary: %@", immutableParameters);

    [self POST:endpointString parameters:immutableParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [self.delegate foursquareHTTPClient:self didPerformRequestWithResponse:responseObject forEndpointConstant:endpointConstant];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.delegate foursquareHTTPClient:self didFailWithError:error];
    }];
}

@end
