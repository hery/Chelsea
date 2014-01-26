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
    
    // Authenticate with Foursquare
    // Following call returns a statusCode. Handle error case here.
    [FSOAuth authorizeUserUsingClientId:ClientId callbackURIString:CallbackURIString];
    
    // Back-end = Parse
    // Location Check-In = Foursquare
    // Real-Time events = Pusher
    
    // Bind search bar to search function
    // On location tap: check location using GPS
    //      if close: check-in with Foursquare
    //      else: alert! you're not at that location!
    // After check-in: enter channel room
    // List users: on "user tap": open channel
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (void)handleAuthenticationForURL:(NSURL *)url
{
    NSDictionary *queryDictionary = [self parseQueryString:[url query]];
    fourSquareAccessCodeString = [queryDictionary objectForKey:@"code"];
    
    CGFloat latitude = 40.745176;
    CGFloat longitude = -73.997215;
    NSString *ll = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
    NSString *searchEndPointURL = @"https://api.foursquare.com/v2/venues/search";
    NSDictionary *parameters = @{@"oauth_token":fourSquareAccessCodeString, @"ll":ll};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:searchEndPointURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success!");
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure!");
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
}

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
