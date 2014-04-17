//
//  FoursquareHTTPClientDelegate.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoursquareHTTPClient.h"

@class HomeViewControllerDataSource;

@interface FoursquareHTTPClientDelegate : NSObject <FoursquareHTTPClientDelegate>

@property (nonatomic, strong) HomeViewControllerDataSource *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@end
