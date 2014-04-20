//
//  ChatTableViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/4/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>

@interface ChatTableViewController : UIViewController <SRWebSocketDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (nonatomic, strong) SRWebSocket *chelseaWebSocket;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** venue and checked-in users info */
@property (nonatomic, strong) NSDictionary *venue;
@property (nonatomic, strong) NSArray *checkedInUsersArray;

/** user info */
@property (nonatomic, strong) NSDictionary *chelseaUserInfo;

@property (nonatomic, strong) NSMutableArray *messagesArray;

@end
