//
//  ChelseaHTTPClient.h
//  Chelsea
//
//  Created by pandaman on 8/6/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface ChelseaHTTPClient : AFHTTPSessionManager

+ (ChelseaHTTPClient *)sharedChelseaHTTPClient;
- (instancetype)initWithBaseURL:(NSURL *)url;

@end
