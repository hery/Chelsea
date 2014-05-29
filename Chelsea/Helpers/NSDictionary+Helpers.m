//
//  NSDictionary+Helpers.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 2/3/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "NSDictionary+Helpers.h"

@implementation NSDictionary (Helpers)

+ (NSDictionary *)parseQueryString:(NSString *)queryString
{
    NSMutableDictionary *queryDictionary = [NSMutableDictionary new];
    NSArray *queryStringElements = [queryString componentsSeparatedByString:@"&"];
    
    NSArray *elementArray;
    NSString *keyString;
    NSString *valueString;
    
    for (NSString *elementString in queryStringElements) {
        elementArray = [elementString componentsSeparatedByString:@"="];
        keyString = [[elementArray objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        valueString = [[elementArray objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [queryDictionary setObject:valueString forKey:keyString];
    }
    return (NSDictionary *)queryDictionary;
}

@end
