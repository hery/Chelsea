//
//  ChatTableViewController.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/4/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ChatTableViewController.h"
#import "constants.h"
#import <RDRStickyKeyboardView.h>

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController

#pragma mark - Object lifecyle

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messagesArray = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Views setup
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ChatCell"];
    
    _stickyKeyboardView = [[RDRStickyKeyboardView alloc] initWithScrollView:_tableView];
    _stickyKeyboardView.frame = self.view.bounds;
    _stickyKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [_stickyKeyboardView.inputView.rightButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_stickyKeyboardView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _messagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    if (_messagesArray.count > 0) {
        NSString *messageString = [[NSString alloc] initWithFormat:@"%@: %@",
                                   _messagesArray[indexPath.row][@"chatId"],
                                   _messagesArray[indexPath.row][@"text"]];
        cell.textLabel.text = messageString;
    }
    return cell;
}

#pragma mark - WebSocket delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Websocket opened.");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Websocket received message: %@", message);
    NSData *decodedDictionary = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:decodedDictionary options:NSJSONReadingMutableContainers error:nil];
    [_messagesArray addObject:jsonDictionary];
    [self.tableView reloadData];
    
    NSLog(@"New message array: %@", _messagesArray);
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Websocket failed with error: %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Websocket closed with code %li, because <%@>. It was %@.",
          code,
          reason,
          wasClean ? @"clean" : @"not clean");
}

#pragma mark - Notifications

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
- (void)sendMessage
{
    [_stickyKeyboardView.inputView.textView endEditing:YES];
    
    NSString *message = _stickyKeyboardView.inputView.textView.text;
    if (!message)
        message = @"Prout!";
    
    NSLog(@"%@", _stickyKeyboardView.inputView.textView.text);
    
    NSLog(@"Setting up chat message...");
    NSLog(@"User info: %@", _chelseaUserInfo);
    NSLog(@"Venue: %@", _venue);
    NSLog(@"Message: %@", message);
    
    NSDictionary *packetDictionary = @{@"userId":_chelseaUserInfo[@"userId"],
                                       @"chatId":_chelseaUserInfo[@"chatId"],
                                       @"venueId":_venue[@"id"],
                                       @"text":message,
                                       @"type":@"chat"};

    NSData *jsonPacket = [NSJSONSerialization dataWithJSONObject:packetDictionary 
                                                        options:NSJSONWritingPrettyPrinted error:nil];
    NSString *packetString = [[NSString alloc] initWithData:jsonPacket encoding:NSUTF8StringEncoding];
    NSLog(@"Sending <%@>", packetDictionary);
    [_chelseaWebSocket send:packetString];
//    return YES;
}

@end
