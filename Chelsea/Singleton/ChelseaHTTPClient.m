//
//  ChelseaHTTPClient.m
//  Chelsea
//
//  Created by pandaman on 8/6/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ChelseaHTTPClient.h"
#import "constants.h"

@implementation ChelseaHTTPClient

+ (ChelseaHTTPClient *)sharedChelseaHTTPClient
{
    static ChelseaHTTPClient *chelseaHTTPClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chelseaHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:chelseaBaseURL]];
    });
    return chelseaHTTPClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    }
    return self;
}

@end
