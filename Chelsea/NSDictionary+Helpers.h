//
//  NSDictionary+Helpers.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 2/3/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Helpers)

/**
 * Parse the query string into a dictionary.
 * @param queryString String to be parsed.
 * @return A dictionary containing the URL query parameters.
 */
+ (NSDictionary *)parseQueryString:(NSString *)queryString;

@end
