//
//  ChelseaWebSocketDelegate.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 4/4/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChelseaWebSocket.h"

@protocol ChelseaWebSocketDelegate <NSObject>

- (void)webSocket:(ChelseaWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocket:(ChelseaWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(ChelseaWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end

@interface ChelseaWebSocketDelegate : NSObject

@end
