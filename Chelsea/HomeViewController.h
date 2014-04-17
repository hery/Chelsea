//
//  HomeViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewControllerDataSource;
@class FoursquareHTTPClient;

@interface HomeViewController : UIViewController <UITableViewDelegate, UISearchBarDelegate> {
    HomeViewControllerDataSource *dataSource;
    FoursquareHTTPClient *sharedFoursquareHTTPClient;
}

@property (weak, nonatomic) IBOutlet UISearchBar *venueSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *venueTableView;

- (void)handleAuthenticationForURL:(NSURL *)url;

@end
