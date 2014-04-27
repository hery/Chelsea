//
//  HomeViewController.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <FSOAuth.h>
#import <AFHTTPRequestOperationManager.h>

#import "HomeViewController.h"
#import "HomeViewControllerDataSource.h"
#import "FoursquareHTTPClient.h"
#import "FoursquareHTTPClientDelegate.h"

#import "NSDictionary+Helpers.h"

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
    
    self.title = @"Check-In";
    
    _venueSearchBar.delegate = self;
    
    // dataSource is nil if initialized in initializer. Why?
    dataSource = [HomeViewControllerDataSource new];
    _venueTableView.dataSource = dataSource;
    
    _venueTableView.delegate = self;
    [_venueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *foursquareAccessCodeString = [standardUserDefaults objectForKey:@"foursquareAccessCode"];

    NSLog(@"Current FS token: %@", foursquareAccessCodeString);
    
    // Todo: check token validity
    if (!foursquareAccessCodeString) {
        NSLog(@"No valid token found. Reauthenticating...");
        NSLog(@"%i",(int)[FSOAuth authorizeUserUsingClientId:ClientId callbackURIString:CallbackURIString]);
    }
    
    sharedFoursquareHTTPClient = [FoursquareHTTPClient sharedFoursquareHTTPClient];
    FoursquareHTTPClientDelegate *delegate = [[FoursquareHTTPClientDelegate alloc] init];
    delegate.navigationController = self.navigationController;
    delegate.dataSource = dataSource;
    delegate.tableView = _venueTableView;
    sharedFoursquareHTTPClient.delegate = delegate;
}

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Check-in at: %@", dataSource.venuesArray[indexPath.row]);
    NSDictionary *additionalParameters = @{@"v":@"20140417",
                                           @"venueId":dataSource.venuesArray[indexPath.row][@"id"]};
    [sharedFoursquareHTTPClient performPOSTRequestForEndpointString:@"checkins/add" endpointConstant:FoursquareHTTPClientEndPointCheckIn additionalParameters:additionalParameters];
}

#pragma mark Foursquare API methods

- (void)handleAuthenticationForURL:(NSURL *)url
{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    FSOAuthErrorCode *error = NULL;
    NSString *accessCodeString = [FSOAuth accessCodeForFSOAuthURL:url error:error];
    if (error == FSOAuthStatusSuccess) {
        NSLog(@"FS auth succeeded. Token: <%@>", accessCodeString);
        [standardUserDefault setObject:accessCodeString forKey:@"foursquareAccessCode"];
    } else {
        NSLog(@"Error getting FS token: %i", (int)error);
    }
}

# pragma mark Search bar delegate methods 

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
    
    // Hard-coded locations should be replaced with user's location.
    CGFloat latitude = 40.745176;
    CGFloat longitude = -73.997215;
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
