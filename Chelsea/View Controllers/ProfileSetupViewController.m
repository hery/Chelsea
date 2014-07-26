//
//  ProfileSetupViewController.m
//  Chelsea
//
//  Created by pandaman on 7/26/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ProfileSetupViewController.h"
#import "ChelseaTextField.h"

static const CGFloat topMargin = 50.0f;
static const CGFloat leftMargin = 10.0f;
static const CGFloat verticalSeparator = 10.0f;

@interface ProfileSetupViewController ()

@end

@implementation ProfileSetupViewController

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
    
    CGFloat verticalCount = 0.0f;
    
    chatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                     topMargin,
                                                                     [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                     10)];
    chatIdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    chatIdLabel.numberOfLines = 0;
    chatIdLabel.textColor = [UIColor whiteColor];
    chatIdLabel.text = @"Nickname: how users with a peek level smaller than your anonymity level will identify you.";
    [chatIdLabel sizeToFit];
    [self.view addSubview:chatIdLabel];
    
    verticalCount += chatIdLabel.frame.origin.y + chatIdLabel.frame.size.height + verticalSeparator;
    
    chatIdTextField = [[ChelseaTextField alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                                           verticalCount,
                                                                                          [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                                           50)];
    chatIdTextField.placeholder = @"Pandaman";
    chatIdTextField.delegate = self;
    [self.view addSubview:chatIdTextField];
    
    verticalCount += chatIdTextField.frame.size.height + verticalSeparator;
    
    realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                      verticalCount,
                                                                       [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                       10)];
    realNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    realNameLabel.numberOfLines = 0;
    realNameLabel.textColor = [UIColor whiteColor];
    realNameLabel.text = @"Real name: for those with a higher peek level.";
    [realNameLabel sizeToFit];
    [self.view addSubview:realNameLabel];
    
    verticalCount += realNameLabel.frame.size.height + verticalSeparator;
    
    realNameTextField = [[ChelseaTextField alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                                            verticalCount,
                                                                                            [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                                             50)];
    realNameTextField.delegate = self;
    realNameTextField.placeholder = @"John Smith";
    [self.view addSubview:realNameTextField];
    
    verticalCount += realNameTextField.frame.size.height + verticalSeparator;
    
    profilePictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                   verticalCount,
                                                                   [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                   10)];
    profilePictureLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    profilePictureLabel.numberOfLines = 0;
    profilePictureLabel.textColor = [UIColor whiteColor];
    profilePictureLabel.text = @"Your picture: also for those with a higher peek level.";
    [profilePictureLabel sizeToFit];
    [self.view addSubview:profilePictureLabel];

    verticalCount += profilePictureLabel.frame.size.height + verticalSeparator;
    
    profilePictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                            verticalCount,
                                                                           [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                            150)];
    profilePictureImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:profilePictureImageView];
    
    verticalCount += profilePictureImageView.frame.size.height + verticalSeparator;
    
    UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin,
                                                                     verticalCount,
                                                                     [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                     50)];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f]];
    [playButton setTitle:@"Let's do it!" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:playButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.7f delay:0.5f usingSpringWithDamping:0.7f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect chatIdLabelFrame = chatIdLabel.frame;
        chatIdLabelFrame.origin.x = leftMargin;
        chatIdLabel.frame = chatIdLabelFrame;
        
        CGRect chatIdTextFieldFrame = chatIdTextField.frame;
        chatIdTextFieldFrame.origin.x = leftMargin;
        chatIdTextField.frame = chatIdTextFieldFrame;
        
        CGRect realNameLabelFrame = realNameLabel.frame;
        realNameLabelFrame.origin.x = leftMargin;
        realNameLabel.frame = realNameLabelFrame;
        
        CGRect realNameTextFiedFrame = realNameTextField.frame;
        realNameTextFiedFrame.origin.x = leftMargin;
        realNameTextField.frame = realNameTextFiedFrame;
        
        CGRect profilePictureLabelFrame = profilePictureLabel.frame;
        profilePictureLabelFrame.origin.x = leftMargin;
        profilePictureLabel.frame = profilePictureLabelFrame;
        
        CGRect profilePictureFrame = profilePictureImageView.frame;
        profilePictureFrame.origin.x = leftMargin;
        profilePictureImageView.frame = profilePictureFrame;
    } completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
