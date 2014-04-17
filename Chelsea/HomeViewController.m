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

#import "NSDictionary+Helpers.h"

#include "constants.h"

// Singleton should store the base URL.
NSString * const searchEndPointURL = @"https://api.foursquare.com/v2/venues/search";
NSString * const DATEVERIFIED = @"20130203";

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

    // Todo: check token validity
    if (!foursquareAccessCodeString)
        NSLog(@"%i",(int)[FSOAuth authorizeUserUsingClientId:ClientId callbackURIString:CallbackURIString]);
}

#pragma mark - Tableview delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Check-in at %@", dataSource.venueNameArray[indexPath.row]);
}

#pragma mark Foursquare API methods

- (void)handleAuthenticationForURL:(NSURL *)url
// We just need to save the authentication token for subsequent requests.
{
    NSDictionary *queryDictionary = [NSDictionary parseQueryString:[url query]];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault setObject:[queryDictionary objectForKey:@"code"] forKey:@"foursquareAccessCode"];
    NSLog(@"New Foursqare access token: %@", [queryDictionary objectForKey:@"code"]);
}

- (void)searchVenuesForQueryString:(NSString *)queryString
{
    // Hard-coded locations should be replaced with user's location.
    CGFloat latitude = 40.745176;
    CGFloat longitude = -73.997215;
    NSString *ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fourquareAccessCode = [standardUserDefaults objectForKey:@"foursquareAccessCode"];
    NSLog(@"Current access token: %@", fourquareAccessCode);
    NSDictionary *parameters = @{@"oauth_token":fourquareAccessCode, @"ll":ll, @"query":queryString, @"limit":@5, @"v":DATEVERIFIED};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableArray *indexPathArray = [NSMutableArray new];
    
    [manager GET:searchEndPointURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!");
        
        NSArray *venuesArray = [[responseObject objectForKey:@"response"] objectForKey:@"venues"];
        int i = 0;
        
        for (NSDictionary *venue in venuesArray) {
            // Here we use the venue's name to populate the data source,
            // But it'd be nice to save the venue's unique id to identify chat rooms.
            [dataSource.venueNameArray addObject:[venue objectForKey:@"name"]];
            NSLog(@"%@", venue[@"name"]);
            [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            i++;
        }
        
        // Sorting the array alphabetically here would be nice.
        
        [_venueTableView beginUpdates];
        [_venueTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
        [_venueTableView endUpdates];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure for:");
        
        NSLog(@"URL: %@", [[operation request] URL]);
        NSLog(@"Error code: %li", (long)[error code]);
        NSLog(@"Error message: %@", [error localizedDescription]);
        
        if ([[error localizedDescription] isEqualToString:@"Request failed: unauthorized (401)"])
            NSLog(@"%i",(int)[FSOAuth authorizeUserUsingClientId:ClientId callbackURIString:CallbackURIString]);
    }];
}

# pragma mark Search bar delegate methods 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Searching for venues...");
    // Wipe current results, if any.
    NSMutableArray *indexPathOfCurrentVenues = [[NSMutableArray alloc] init];
    [dataSource.venueNameArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [indexPathOfCurrentVenues addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
    }];
    
    [dataSource.venueNameArray removeAllObjects];
    
    [_venueTableView beginUpdates];
    [_venueTableView deleteRowsAtIndexPaths:indexPathOfCurrentVenues withRowAnimation:UITableViewRowAnimationRight];
    [_venueTableView endUpdates];
    
    [_venueSearchBar resignFirstResponder];
    NSString *queryString = [searchBar text];
    [self searchVenuesForQueryString:queryString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
