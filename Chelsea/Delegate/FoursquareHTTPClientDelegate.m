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
#import "ChatTableViewController.h"

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
            
            if (venuesArray.count > 0) {
                NSLog(@"Venue objects array: %@", venuesArray);
                
                NSMutableArray *indexPathArray = [NSMutableArray new];
                [venuesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [_dataSource.venuesArray addObject:(NSDictionary *)obj];
                    [indexPathArray addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
                }];
                
                [_tableView beginUpdates];
                [_tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationLeft];
                [_tableView endUpdates];
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Whoops" message:@"We can't find any venue with that name where you are. Get closer!" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil] show];
            }
            
            break;
        }
        case FoursquareHTTPClientEndPointCheckIn:
        {
            NSLog(@"Check-In successful!");
            NSLog(@"Response: %@", response);
            
            _venue = response[@"response"][@"checkin"][@"venue"];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            _chatTableViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"chatTableViewController"];
            
            // Websocket setup
            NSString *urlString = socketServerAddress;
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _chelseaWebSocket = [[SRWebSocket alloc] initWithURLRequest:request];
            _chatTableViewController.chelseaWebSocket = _chelseaWebSocket;
            _chelseaWebSocket.delegate = _chatTableViewController;
            NSLog(@"Opening websocket...");
            [_chelseaWebSocket open];
            
            UIAlertView *checkInSuccessAlertView = [[UIAlertView alloc] initWithTitle:@"Checked-In!" message:@"Choose a bunch of letters to identify yourself" delegate:self cancelButtonTitle:@"Let's go!" otherButtonTitles:nil];
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
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Back"]) // `no result` alert view
        return;
    
    if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) { // `description name` alert view
        UIAlertView *emptyName = [[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You can't use an empty description, try again." delegate:self cancelButtonTitle:@"Let's go!" otherButtonTitles:nil];
        emptyName.alertViewStyle = UIAlertViewStylePlainTextInput;
        [emptyName show];
        return;
    }
    
    NSLog(@"You will be identified as %@.", [alertView textFieldAtIndex:0].text);
    
    // Check-In (ws) message setup
    // Get user's uuid
    NSUUID *identifierForVendor = [UIDevice currentDevice].identifierForVendor;
    NSString *userUUID = [identifierForVendor UUIDString];
    // Get user's chatId
    NSString *chatId = [alertView textFieldAtIndex:0].text;
    // Get FS venueId
    NSString *venueId = _venue[@"id"];
    // Package and send message
    NSDictionary *packetDictionary = @{@"userId":userUUID, @"chatId":chatId, @"venueId": venueId, @"type": @"setup", @"text":[NSString stringWithFormat:@"%@ joined", chatId]};
    NSError *error;
    NSData *jsonPacket = [NSJSONSerialization dataWithJSONObject:packetDictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString *packetString = [[NSString alloc] initWithData:jsonPacket encoding:NSUTF8StringEncoding];
    [_chelseaWebSocket send:packetString];
    
    // todo: check that the server properly received the setup message and push chat vc on success
    
    _chatTableViewController.title = [NSString stringWithFormat:@"@ %@", _venue[@"name"]];
    _chatTableViewController.venue = _venue;
    _chatTableViewController.chelseaUserInfo = @{@"userId":userUUID, @"chatId":chatId};
    [self.navigationController pushViewController:_chatTableViewController animated:YES];
}

@end
