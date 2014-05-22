//
//  HomeViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class HomeViewControllerDataSource;
@class FoursquareHTTPClient;


@interface HomeViewController : UIViewController <UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate, UIWebViewDelegate> {
    HomeViewControllerDataSource *dataSource;
    FoursquareHTTPClient *sharedFoursquareHTTPClient;
}

@property (nonatomic, strong) UIWebView *loginWebView;
@property (weak, nonatomic) IBOutlet UISearchBar *venueSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *venueTableView;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationDegrees currentLatitude;
@property (nonatomic, assign) CLLocationDegrees currentLongitude;

- (void)handleAuthenticationForURL:(NSURL *)url;

@end
