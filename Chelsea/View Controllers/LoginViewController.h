//
//  LoginViewController.h
//  Chelsea
//
//  Created by pandaman on 5/21/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UIWebView *loginWebView;

- (void)handleAuthenticationForURL:(NSURL *)url;

@end
