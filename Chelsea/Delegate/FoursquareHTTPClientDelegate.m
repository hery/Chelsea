//
//  FoursquareHTTPClientDelegate.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "FoursquareHTTPClientDelegate.h"
#import "FoursquareHTTPClient.h"
#import "HomeViewControllerDataSource.h"
#import "LocationTableViewController.h"

#import <FSOAuth.h>

#import "constants.h"

@implementation FoursquareHTTPClientDelegate

#pragma mark - Foursquare Delegate Methods

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didPerformRequestWithResponse:(NSDictionary *)response forEndpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant
{
    switch (endpointConstant) {
        case FoursquareHTTPClientEndpointSearch:
        {
            NSArray *venuesArray = [[response objectForKey:@"response"] objectForKey:@"venues"];
            NSLog(@"Venues query got %li results.", venuesArray.count);
            
            NSMutableArray *indexPathArray = [NSMutableArray new];
            [venuesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [_dataSource.venuesArray addObject:(NSDictionary *)obj];
                [indexPathArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
            }];
            
            [_tableView beginUpdates];
            [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
            [_tableView endUpdates];
            
            break;
        }
        case FoursquareHTTPClientEndPointCheckIn:
        {
            NSLog(@"Check-In successful!");
            NSLog(@"Response: %@", response);
            
            UIAlertView *checkInSuccessAlertView = [[UIAlertView alloc] initWithTitle:@"Checked-In!" message:@"Choose a bunch of words to identify yourself" delegate:self cancelButtonTitle:@"Let's go!" otherButtonTitles:nil];
            checkInSuccessAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [checkInSuccessAlertView show];
        }
        default:
            break;
    }
}

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"Request failed. Reason: %@", error);
    
    NSLog(@"Error code: %li", (long)[error code]);
    NSLog(@"Error message: %@", [error localizedDescription]);

    if ([[error localizedDescription] isEqualToString:@"Request failed: unauthorized (401)"])
        NSLog(@"%i",(int)[FSOAuth authorizeUserUsingClientId:ClientId callbackURIString:CallbackURIString]);
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"You will be identified as %@.", [alertView textFieldAtIndex:0].text);
    SRWebSocket *chelseaWebSocket = [SRWebSocket new];
    LocationTableViewController *locationTableViewController = [LocationTableViewController new];
    chelseaWebSocket.delegate = locationTableViewController;
    [self.navigationController pushViewController:locationTableViewController animated:YES];
}

@end
