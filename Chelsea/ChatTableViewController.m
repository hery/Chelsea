//
//  ChatTableViewController.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/4/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ChatTableViewController.h"
#import "constants.h"

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Views setup
    _inputTextField.frame = CGRectMake(0,
                                       [UIScreen mainScreen].bounds.size.height-50,
                                       [UIScreen mainScreen].bounds.size.width,
                                       50);
    _inputTextField.backgroundColor = [UIColor whiteColor];
    _inputTextField.layer.borderWidth = 1;
    _inputTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _inputTextField.delegate = self;
    [self.view addSubview:_inputTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
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
                                   _messagesArray[indexPath.row][@"userId"],
                                   _messagesArray[indexPath.row][@"message"]];
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
    [_messagesArray addObject:message];
    [self.tableView reloadData];
    
    NSLog(@"New message array: %@", _messagesArray                                          );
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

- (void)keyboardDidShow:(NSNotification *)notification
{
    // Update textfield frame
    NSDictionary *userInfoDictionary = [notification userInfo];
    CGRect keyboardEndFrame = [userInfoDictionary[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect newFrameForInputTextField = _inputTextField.frame;
    newFrameForInputTextField.origin.y = keyboardEndFrame.origin.y - newFrameForInputTextField.size.height;
    _inputTextField.frame = newFrameForInputTextField;
    
    CGRect tableViewEndFrame = _tableView.frame;
    tableViewEndFrame.origin.y = _inputTextField.frame.origin.y - _tableView.frame.size.height;
    _tableView.frame = tableViewEndFrame;
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    // Update textfield frame
    NSDictionary *userInfoDictionary = [notification userInfo];
    CGRect keyboardEndFrame = [userInfoDictionary[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGRect newFrameForInputTextField = _inputTextField.frame;
    newFrameForInputTextField.origin.y = keyboardEndFrame.origin.y - newFrameForInputTextField.size.height;
    _inputTextField.frame = newFrameForInputTextField;
    
    CGRect tableViewEndFrame = _tableView.frame;
    tableViewEndFrame.origin.y = _inputTextField.frame.origin.y - _tableView.frame.size.height;
    _tableView.frame = tableViewEndFrame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_inputTextField resignFirstResponder];
    NSString *message = _inputTextField.text;
    
    NSLog(@"Setting up chat message...");
    NSLog(@"User info: %@", _chelseaUserInfo);
    NSLog(@"Venue: %@", _venue);
    NSLog(@"Message: %@", message);
    
    NSDictionary *packetDictionary = @{@"userId":_chelseaUserInfo[@"userId"],
                                       @"chatId":_chelseaUserInfo[@"chatId"],
                                       @"venueId":_venue[@"id"],
                                       @"message":message,
                                       @"type":@"chat"};

    NSData *jsonPacket = [NSJSONSerialization dataWithJSONObject:packetDictionary 
                                                        options:NSJSONWritingPrettyPrinted error:nil];
    NSString *packetString = [[NSString alloc] initWithData:jsonPacket encoding:NSUTF8StringEncoding];
    NSLog(@"Sending <%@>", packetDictionary);
    [_chelseaWebSocket send:packetString];
    return YES;
}

@end
