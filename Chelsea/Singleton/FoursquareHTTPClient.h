//
//  FoursquareHTTPClient.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@protocol FoursquareHTTPClientDelegate;

@interface FoursquareHTTPClient : AFHTTPSessionManager

@property (nonatomic, strong) id <FoursquareHTTPClientDelegate> delegate;
@property (nonatomic, copy) NSString *authToken;

+ (FoursquareHTTPClient *)sharedFoursquareHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

/** Handles <Search> request */
- (void)performGETRequestForEndpoint:(NSString *)endpoint additionalParameters:(NSDictionary *)additionalParameters;

/** Handles <Check-In> request */
- (void)performPOSTRequestForEndpoint:(NSString *)endpoint additionalParameters:(NSDictionary *)additionalParameters;

@end

@protocol FoursquareHTTPClientDelegate <NSObject>;
@optional

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didPerformRequestWithResponse:(NSDictionary *)response;
- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didFailWithError:(NSError *)error;

@end
