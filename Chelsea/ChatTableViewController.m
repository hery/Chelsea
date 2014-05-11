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
#import "ChatTableViewCell.h"

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController

#pragma mark - Object Lifecyle

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _keepSocketAlive = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _messagesArray = [[NSMutableArray alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:12/255.0f green:47/255.0f blue:100/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Views setup
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorColor = [UIColor colorWithRed:0.887 green:0.887 blue:0.887 alpha:1];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:@"ChatCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height+30, 0, 0, 0);
    
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

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:style};
    
    CGRect messageRect = [_messagesArray[indexPath.row][@"text"] boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                                                               options:NSStringDrawingUsesLineFragmentOrigin
                                                                            attributes:attributes
                                                                               context:nil];
    NSLog(@"Expected height: 40+%f (width is %f)", messageRect.size.height, messageRect.size.width);
    return 40+messageRect.size.height;
}

#pragma mark - Table View Data Source

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
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    if (_messagesArray.count > 0) {
        cell.chatIdLabel.text = _messagesArray[indexPath.row][@"chatId"];
        cell.messageLabel.text = _messagesArray[indexPath.row][@"text"];
//        [cell.messageLabel sizeToFit];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f], NSParagraphStyleAttributeName:style};
        CGRect messageRect = [_messagesArray[indexPath.row][@"text"] boundingRectWithSize:CGSizeMake(320, MAXFLOAT)
                                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                                               attributes:attributes
                                                                                  context:nil];
        NSLog(@"Expected label height: %f", messageRect.size.height);
        NSLog(@"Returned label height: %f", cell.messageLabel.frame.size.height);
        
        // Compute label height manually, because sizeToFit and sizeThatFit won't work.
        
        CGRect newFrameForMessageLabel = cell.messageLabel.frame;
        newFrameForMessageLabel.size.height = messageRect.size.height;
        cell.messageLabel.frame = newFrameForMessageLabel;
    }
    return cell;
}

#pragma mark - WebSocket Delegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"Websocket opened.");
    
    /** Let's keep the session open indefinitely by pinging
     *  the server every 45 seconds.
     *  (server times out after 55 seconds of inactivity)
     */
    
    _keepSocketAlive = YES;
    [self pingServer];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSLog(@"Websocket received message: %@", message);
    NSData *decodedDictionary = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:decodedDictionary options:NSJSONReadingMutableContainers error:nil];
    [_messagesArray addObject:jsonDictionary];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_messagesArray.count-1 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"Websocket failed with error: %@", error);
    
    if ([NSStringFromClass([self.navigationController.visibleViewController class]) isEqualToString:@"ChatTableViewController"])
        [[[UIAlertView alloc] initWithTitle:@"Whoops!"
                                    message:@"Your chat session closed. Check-in again to open a new one."
                                   delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil] show];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"Websocket closed with code %li, because <%@>. It was %@.",
          code,
          reason,
          wasClean ? @"clean" : @"not clean");
    
    if ([NSStringFromClass([self.navigationController.visibleViewController class]) isEqualToString:@"ChatTableViewController"])
        [[[UIAlertView alloc] initWithTitle:@"Whoops!"
                                    message:@"Your chat session closed. Check-in again to open a new one."
                                   delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil] show];
}

#pragma mark - Notifications

- (void)sendMessage
{
    [_stickyKeyboardView.inputView.textView endEditing:YES];
    
    NSString *message = _stickyKeyboardView.inputView.textView.text;
    if (!message)
        message = @"Prout!";
    
    _stickyKeyboardView.inputView.textView.text = @"";
    
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
}

- (void)pingServer
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"Ping.");
        NSDictionary *packetDictionary = @{@"type":@"ping"};
        NSData *jsonPacket = [NSJSONSerialization dataWithJSONObject:packetDictionary
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:nil];
        NSString *packetString = [[NSString alloc] initWithData:jsonPacket encoding:NSUTF8StringEncoding];
        [_chelseaWebSocket send:packetString];
        if (_keepSocketAlive) [self pingServer];
    });
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [_stickyKeyboardView resignFirstResponder];
    NSLog(@"Title for alert view button: %@", [alertView buttonTitleAtIndex:buttonIndex]);
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok!"]) { // expired session alert
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
