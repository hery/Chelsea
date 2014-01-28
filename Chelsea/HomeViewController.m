//
//  HomeViewController.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "HomeViewController.h"
#import <FSOAuth.h>
#import <AFHTTPRequestOperationManager.h>

#include "constants.h"

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
    _venueTableView.dataSource = self;
    _venueTableView.delegate = self;
    [_venueTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    venueNameArray = [[NSMutableArray alloc] init];
    
    // Authenticate with Foursquare
    // Following call returns a statusCode.
    // Todo: Handle error case using status code.
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *foursquareAccessCodeString = [standardUserDefaults objectForKey:@"foursquareAccessCode"];
    if (!foursquareAccessCodeString)
        [FSOAuth authorizeUserUsingClientId:ClientId callbackURIString:CallbackURIString];
}

#pragma mark Data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [venueNameArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_venueTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([venueNameArray count] > 0)
        cell.textLabel.text = venueNameArray[indexPath.row];
    else
        cell.textLabel.text = @"nil";
    return cell;
}

#pragma mark Foursquare API methods

- (void)handleAuthenticationForURL:(NSURL *)url
{
    NSDictionary *queryDictionary = [self parseQueryString:[url query]];
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    [standardUserDefault setObject:[queryDictionary objectForKey:@"code"] forKey:@"foursquareAccessCode"];
}

- (void)searchVenuesForQueryString:(NSString *)queryString
{
    CGFloat latitude = 40.745176;
    CGFloat longitude = -73.997215;
    NSString *ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fourquareAccessCode = [standardUserDefaults objectForKey:@"foursquareAccessCode"];
    NSDictionary *parameters = @{@"oauth_token":fourquareAccessCode, @"ll":ll, @"query":queryString};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableArray *indexPathArray = [NSMutableArray new];
    
    [manager GET:searchEndPointURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!");
        
        NSArray *responseArray = [[responseObject objectForKey:@"response"] objectForKey:@"groups"];
        NSArray *venuesArray = [[responseArray objectAtIndex:0] objectForKey:@"items"];
        int i = 0;
        
        for (NSDictionary *venue in venuesArray) {
            // Here we use the venue's name to populte the data source,
            // But it'd be nice to save the venue's unique id to identify chat rooms.
            [venueNameArray addObject:[venue objectForKey:@"name"]];
            [indexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            i++;
        }
        
        // Sorting the array alphabetically here would be nice.
        
        [_venueTableView beginUpdates];
        [_venueTableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [_venueTableView endUpdates];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!");
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

# pragma mark Search bar delegate methods 

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // Wipe current results, if any.
    NSMutableArray *indexPathOfCurrentVenues = [[NSMutableArray alloc] init];
    for (int i=0; i<[venueNameArray count]; i++) {
        [indexPathOfCurrentVenues addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        [venueNameArray removeObjectAtIndex:i];
    }
    
    NSLog(@"%@", venueNameArray);
    
    [_venueTableView beginUpdates];
    [_venueTableView deleteRowsAtIndexPaths:indexPathOfCurrentVenues withRowAnimation:UITableViewRowAnimationLeft];
    [_venueTableView endUpdates];
    
    [_venueSearchBar resignFirstResponder];
    NSString *queryString = [searchBar text];
    [self searchVenuesForQueryString:queryString];
}

# pragma mark Utility functions

/**
 Parse the query string into a dictionary.
 Todo: move to a utility class.
 */
- (NSDictionary *)parseQueryString:(NSString *)queryString
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
