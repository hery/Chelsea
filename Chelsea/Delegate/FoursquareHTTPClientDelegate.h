//
//  FoursquareHTTPClientDelegate.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoursquareHTTPClient.h"

#import <SRWebSocket.h>

@class HomeViewControllerDataSource;

@interface FoursquareHTTPClientDelegate : NSObject <FoursquareHTTPClientDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) HomeViewControllerDataSource *dataSource;
@property (nonatomic, strong) UITableView *tableView;

/** Store venue where user checks-in to get a reference to its id when needed */
@property (nonatomic, strong) NSDictionary *venue;

@end
