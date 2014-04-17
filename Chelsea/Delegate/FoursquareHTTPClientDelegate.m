//
//  FoursquareHTTPClientDelegate.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "FoursquareHTTPClientDelegate.h"
#import "FoursquareHTTPClient.h"

@implementation FoursquareHTTPClientDelegate

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didPerformRequestWithResponse:(NSDictionary *)response
{
    NSLog(@"Request succeeded. Got:");
    NSLog(@"%@", response);
}

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"Request failed. Reason: %@", error);
}

@end
