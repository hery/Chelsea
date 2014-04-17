//
//  FoursquareHTTPClient.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol FoursquareHTTPClientDelegate;


typedef NS_ENUM(NSInteger, FoursquareHTTPClientEndpoint) {
    FoursquareHTTPClientEndpointSearch,
    FoursquareHTTPClientEndPointCheckIn
};

@interface FoursquareHTTPClient : AFHTTPSessionManager

@property (nonatomic, strong) id <FoursquareHTTPClientDelegate> delegate;
@property (nonatomic, copy) NSString *authToken;

+ (FoursquareHTTPClient *)sharedFoursquareHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

/** Handles <Search> request */
- (void)performGETRequestForEndpointString:(NSString *)endpointString endpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant additionalParameters:(NSDictionary *)additionalParameters;

/** Handles <Check-In> request */
- (void)performPOSTRequestForEndpointString:(NSString *)endpointString endpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant additionalParameters:(NSDictionary *)additionalParameters;

@end

@protocol FoursquareHTTPClientDelegate <NSObject>;
@optional

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didPerformRequestWithResponse:(NSDictionary *)response forEndpointConstant: (FoursquareHTTPClientEndpoint)endpointConstant;
- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didFailWithError:(NSError *)error;

@end
