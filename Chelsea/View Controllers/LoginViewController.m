//
//  LoginViewController.m
//  Chelsea
//
//  Created by pandaman on 5/21/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Foursquare API methods

- (void)handleAuthenticationForURL:(NSURL *)url
{
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessCodeString = [url fragment];
    NSArray *accessCodeArray = [accessCodeString componentsSeparatedByString:@"="];
    accessCodeString = accessCodeArray[1];
    if (accessCodeString) { // todo: do a more accurate check here
        NSLog(@"FS auth succeeded. Token: <%@>", accessCodeString);
        [standardUserDefault setObject:accessCodeString forKey:@"foursquareAccessCode"];
        NSLog(@"Subviews before removing login view: %@", self.view.subviews);
        NSLog(@"%@", _loginWebView);
        [_loginWebView removeFromSuperview];
        NSLog(@"Subviews after removing login view: %@", self.view.subviews);
        NSLog(@"%@", _loginWebView);
    } else {
        NSLog(@"Error getting FS token.");
    }
}

@end
