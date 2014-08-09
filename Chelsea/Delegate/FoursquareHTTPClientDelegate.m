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

#import "constants.h"

@implementation FoursquareHTTPClientDelegate

#pragma mark - Foursquare Delegate Methods

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didPerformRequestWithResponse:(NSDictionary *)response forEndpointConstant:(FoursquareHTTPClientEndpoint)endpointConstant
{
    switch (endpointConstant) {
        case FoursquareHTTPClientEndpointSearch:
        {
            NSArray *venuesArray = [[response objectForKey:@"response"] objectForKey:@"venues"];
            NSLog(@"Venues query got %li results.", (unsigned long)venuesArray.count);
            
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
            _checkedInUser =  response[@"response"][@"checkin"][@"user"];
            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            _chatTableViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"chatTableViewController"];
            
            // Websocket setup
            NSString *urlString = socketServerAddress;
            NSURL *url = [NSURL URLWithString:urlString];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _chelseaWebSocket = [[SRWebSocket alloc] initWithURLRequest:request];
            _chatTableViewController.chelseaWebSocket = _chelseaWebSocket;
            _chelseaWebSocket.delegate = self;
            NSLog(@"Opening websocket...");
            [_chelseaWebSocket open];
        }
        case FoursquareHTTPClientEndpointMe:
        {
            NSString *FSIdString = response[@"response"][@"user"][@"id"];
            NSLog(@"GET /users/self succeeded! Got id: %@", FSIdString);
            [[NSUserDefaults standardUserDefaults] setValue:FSIdString forKey:@"foursquareId"];
            break;
        }
        default:
            break;
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    UIAlertView *checkInSuccessAlertView = [[UIAlertView alloc] initWithTitle:@"Checked-In!" message:[NSString stringWithFormat:@"Welcome to %@", _venue[@"name"]] delegate:self cancelButtonTitle:@"Let's go!" otherButtonTitles:nil];
    [checkInSuccessAlertView show];
}

- (void)foursquareHTTPClient:(FoursquareHTTPClient *)client didFailWithError:(NSError *)error
{
    NSLog(@"Request failed. Reason: %@", error);
    NSLog(@"Error code: %li", (long)[error code]);
    NSLog(@"Error message: %@", [error localizedDescription]);
    
    [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"Check your internet connection!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    _tableView.userInteractionEnabled = YES;

    if ([[error localizedDescription] isEqualToString:@"Request failed: unauthorized (401)"])
        NSLog(@"%@", [error localizedDescription]);
}

- (void)setUpWebsocket
{
    // Check-In (ws) message setup
    // Get user's uuid
    NSUUID *identifierForVendor = [UIDevice currentDevice].identifierForVendor;
    NSString *userUUID = [identifierForVendor UUIDString];
    // Get user's chatId
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [standardUserDefaults valueForKey:@"chatId"];
    // Get FS venueId
    NSString *venueId = _venue[@"id"];
    // We need the user's anonymity level here. Let's start with 1 to implement in-app purchase page.
    NSInteger alLevel = [[standardUserDefaults valueForKey:@"al"] integerValue];
    if (![standardUserDefaults valueForKey:@"al"]) {
        alLevel = 1;
        [standardUserDefaults setValue:@"1" forKey:@"al"];
    }
    alLevel = 0; // Default AL. Set to 0 to debug profile view. Leave to 1 for production.
    NSNumber *AL = [NSNumber numberWithInteger:alLevel];
    NSLog(@"Checking AL: %@", AL);
    // Package and send message
    NSDictionary *packetDictionary = @{@"userId": userUUID,
                                       @"userAL": AL,
                                       @"user": _checkedInUser,
                                       @"chatId": chatId,
                                       @"venueId": venueId,
                                       @"type": @"setup",
                                       @"text": [NSString stringWithFormat:@"%@ joined", chatId]};
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

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"]) // `no internet connection` alert view
        return;
    
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Back"]) // `no result` alert view
        return;
    
    if ([[alertView buttonTitleAtIndex:buttonIndex]  isEqualToString:@"Let's go!"]) {
        [self setUpWebsocket];
        return;
    }
}

@end
