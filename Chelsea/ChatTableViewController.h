//
//  ChatTableViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/4/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SRWebSocket.h>

@interface ChatTableViewController : UITableViewController <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *chelseaWebSocket;

@end
