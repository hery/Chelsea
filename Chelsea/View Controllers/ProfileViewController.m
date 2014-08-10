//
//  ProfileViewController.m
//  Chelsea
//
//  Created by pandaman on 5/28/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ProfileViewController.h"
#import "ChelseaHTTPClient.h"

#import <AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    self.view.backgroundColor = CHELSEA_COLOR;
    self.title = _user[@"chatId"];
    NSLog(@"Current user: %@", _user);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    CGFloat profilePictureRadius = [UIScreen mainScreen].bounds.size.width;

    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30, profilePictureRadius, profilePictureRadius)];
    _profilePicture.backgroundColor = CHELSEA_COLOR;
        
    [self.view addSubview:_profilePicture];
    
    UILabel *chatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + _profilePicture.frame.origin.y + _profilePicture.frame.size.height,
                                                                     [UIScreen mainScreen].bounds.size.width, 50)];
    chatIdLabel.text = _user[@"chatId"];
    chatIdLabel.textColor = [UIColor whiteColor];
    chatIdLabel.textAlignment = NSTextAlignmentLeft;
    chatIdLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
    chatIdLabel.numberOfLines = 0;
    [chatIdLabel sizeToFit];
    [self.view addSubview:chatIdLabel];
    
    UILabel *isActuallyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, chatIdLabel.frame.origin.y + chatIdLabel.frame.size.height,
                                                                         [UIScreen mainScreen].bounds.size.width, 40)];
    isActuallyLabel.text = @"is actually";
    isActuallyLabel.textAlignment = NSTextAlignmentLeft;
    isActuallyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
    isActuallyLabel.numberOfLines = 0;
    isActuallyLabel.textColor = [UIColor whiteColor];
    [isActuallyLabel sizeToFit];
    [self.view addSubview:isActuallyLabel];
    
    UILabel *realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, isActuallyLabel.frame.origin.y + isActuallyLabel.frame.size.height,
                                                                       [UIScreen mainScreen].bounds.size.width, 50)];
    
    realNameLabel.text = _user[@"realName"] ?: @"Stranger";
    realNameLabel.backgroundColor = CHELSEA_COLOR;
    realNameLabel.textColor = [UIColor whiteColor];
    realNameLabel.textAlignment = NSTextAlignmentLeft;
    realNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:28.0f];
    realNameLabel.numberOfLines = 0;
    [realNameLabel sizeToFit];
    [self.view addSubview:realNameLabel];
    

    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/checkchat/profilePictures/%@.png", _user[@"user"][@"id"]]];
    _profilePicture.contentMode = UIViewContentModeCenter;
    _profilePicture.clipsToBounds = YES;
    [_profilePicture sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRefreshCached];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)dismissSelf
{
    NSLog(@"Should dismiss self!");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
