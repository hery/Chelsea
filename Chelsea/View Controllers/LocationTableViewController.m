//
//  LocationTableViewController.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/4/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "LocationTableViewController.h"

@interface LocationTableViewController ()

@end

@implementation LocationTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Location table view controller loaded.");
    NSLog(@"Location table view controller websocket: %@", _chelseaWebSocket);
    
    // Send request to get list of users checked-in at this location.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destinationViewController = segue.destinationViewController;
    destinationViewController.title = @"@playing piano on a snowboard";
}

#pragma mark - Tableview Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - Tableview Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - SRWebSocket Delegate Methods

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Received message: %@", (NSString *)message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Websocket opened for LocationTableViewController.");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Websocket could not open. Reason: %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Websocket closed. Reason: %@. It %@.", reason, wasClean ? @"was clean" : @"was no clean");
}

@end
