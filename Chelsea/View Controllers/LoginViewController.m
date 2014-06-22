//
//  LoginViewController.m
//  Chelsea
//
//  Created by pandaman on 5/21/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "constants.h"

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
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [_loginWebView setNeedsDisplay];
    self.title = @"Sign In";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    _loginWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _loginWebView.backgroundColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    _loginWebView.tag = 1;
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?client_id=%@&redirect_uri=chelsea://foursquare&response_type=token", ClientId]];
    NSLog(@"URL for request: %@", url);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_loginWebView loadRequest:request];
    
    UISwipeGestureRecognizer *goBackGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [_loginWebView addGestureRecognizer:goBackGestureRecognizer];
    
    [self.view addSubview:_loginWebView];
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[UIAlertView alloc] initWithTitle:@"End User License Agreement" message:@"By logging in to CheckChat, I agree that I am prohibited from posting or transmitting any unlawful, threatening, libelous, defamatory, obscene, scandalous, inflammatory, pornographic or profane material." delegate:self cancelButtonTitle:@"Got it!" otherButtonTitles:nil] show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [_loginWebView goBack];
    }
}

#pragma mark Foursquare API methods

- (void)handleAuthenticationForURL:(NSURL *)url
{
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *accessCodeString = [url fragment];
    NSArray *accessCodeArray = [accessCodeString componentsSeparatedByString:@"="];
    accessCodeString = accessCodeArray[1];
    if (accessCodeString) { // todo: do a more accurate check here
        NSLog(@"FS auth succeeded. Token: <%@>", accessCodeString);
        [standardUserDefault setObject:accessCodeString forKey:@"foursquareAccessCode"];
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        HomeViewController *homeViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
        [self.navigationController pushViewController:homeViewController animated:YES];
        NSLog(@"webview: %@", _loginWebView);
    } else {
        NSLog(@"Error getting FS token.");
    }
}

@end
