//
//  HomeViewController.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <AFHTTPRequestOperationManager.h>

#import "HomeViewController.h"
#import "HomeViewControllerDataSource.h"
#import "FoursquareHTTPClient.h"
#import "FoursquareHTTPClientDelegate.h"
#import "ProfileSetupViewController.h"

#import "constants.h"

// Singleton should store the base URL.
NSString * const searchEndPointURL = @"https://api.foursquare.com/v2/venues/search";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    self.title = @"Check-In";
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:12/255.0f green:47/255.0f blue:100/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    _venueSearchBar.delegate = self;
    
    // dataSource is nil if initialized in initializer. Why?
    dataSource = [HomeViewControllerDataSource new];
    _venueTableView.dataSource = dataSource;
    
    _venueTableView.delegate = self;
    [_venueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"venueCells"];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([standardUserDefaults boolForKey:@"profileSetup"] == YES) {
        // Skip to delegate setup.
    } else {
        ProfileSetupViewController *profileSetupViewController = [ProfileSetupViewController new];
        [self.navigationController presentViewController:profileSetupViewController animated:NO completion:nil];
    }
    
    // Set up the FS Client below so that the profile setup VC doesn't override it's delegate
    sharedFoursquareHTTPClient = [FoursquareHTTPClient sharedFoursquareHTTPClient];
    FoursquareHTTPClientDelegate *delegate = [[FoursquareHTTPClientDelegate alloc] init];
    delegate.navigationController = self.navigationController;
    delegate.dataSource = dataSource;
    delegate.tableView = _venueTableView;
    sharedFoursquareHTTPClient.delegate = delegate;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _venueTableView.userInteractionEnabled = YES;

    // Send an empty GET request to wake up heroku instance.
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:chelseaBaseURL]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:@"/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"Pong!");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Couldn't reach Chelsea Tornado. %@", [error localizedDescription]);
    }];
}

#pragma mark - Core Location Methods

- (void)startLocationUpdates
{
    if (nil == _locationManager)
        _locationManager = [CLLocationManager new];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.distanceFilter = 1000;
    [_locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSDate *locationDate = location.timestamp;
    NSTimeInterval intervalSinceNow = [locationDate timeIntervalSinceNow];
    if (abs(intervalSinceNow) < 15) {
        _currentLatitude = location.coordinate.latitude;
        _currentLongitude = location.coordinate.longitude;
        dataSource.currentLatitude = _currentLatitude;
        dataSource.currentLongitude = _currentLongitude;
    } else {
        // Do nothing to save power.
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"CheckChat couldn't find your location. Did you make sure to turn it on?" delegate:nil cancelButtonTitle:@"Back" otherButtonTitles:nil] show];
}

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.userInteractionEnabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _venue = dataSource.venuesArray[indexPath.row];
    [[[UIAlertView alloc] initWithTitle:@"Check In Here?" message:[NSString stringWithFormat:@"Are you sure you want to check in at %@", dataSource.venuesArray[indexPath.row][@"name"]] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil] show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
        // Check In
        NSLog(@"Checking-in at: %@", _venue);
        NSDictionary *additionalParameters = @{@"v":@"20140417",
                                               @"venueId":_venue[@"id"]};
        [sharedFoursquareHTTPClient performPOSTRequestForEndpointString:@"checkins/add" endpointConstant:FoursquareHTTPClientEndPointCheckIn additionalParameters:additionalParameters];
    } else {
        _venueTableView.userInteractionEnabled = YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

# pragma mark Search bar delegate methods 

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self startLocationUpdates];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Searching for venues...");
    // Wipe current results, if any.
    NSMutableArray *indexPathOfCurrentVenues = [[NSMutableArray alloc] init];
    [dataSource.venuesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [indexPathOfCurrentVenues addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [dataSource.venuesArray removeAllObjects];
    
    [_venueTableView beginUpdates];
    [_venueTableView deleteRowsAtIndexPaths:indexPathOfCurrentVenues withRowAnimation:UITableViewRowAnimationRight];
    [_venueTableView endUpdates];
    
    [_venueSearchBar resignFirstResponder];
    NSString *queryString = [searchBar text];
    
    CGFloat latitude, longitude;
    
    latitude = _currentLatitude;
    longitude = _currentLongitude;
    
    if (latitude == 0.0f || longitude == 0.0f) {
        latitude = 40.745176;
        longitude = -73.997215;
    }

    NSString *ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSDictionary *parameters = @{@"ll":ll, @"query":queryString, @"limit":@5, @"radius":@"1000", @"intent":@"checkin"};
    
    [sharedFoursquareHTTPClient performGETRequestForEndpointString:@"venues/search" endpointConstant:FoursquareHTTPClientEndpointSearch additionalParameters:parameters];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
