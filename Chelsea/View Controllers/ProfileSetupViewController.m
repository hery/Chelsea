//
//  ProfileSetupViewController.m
//  Chelsea
//
//  Created by pandaman on 7/26/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "ProfileSetupViewController.h"
#import "ChelseaTextField.h"

static const CGFloat topMargin = 30.0f;
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
    
    NSLog(@"Loaded profile setup view view controller.");
    CGFloat verticalCount = topMargin;
    
    headerViewTopMargin = verticalCount;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                                  -50,
                                                                 [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                  50)];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [headerView addSubview:logoImageView];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 + leftMargin, 0, headerView.frame.size.width - 50 - leftMargin, 50)];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
    headerLabel.text = @"Let's set you up";
    headerLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:headerLabel];
    
    [self.view addSubview:headerView];
    
    verticalCount += headerView.frame.size.height + verticalSeparator;
    
    chatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                     verticalCount,
                                                                     [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                     10)];
    chatIdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    chatIdLabel.numberOfLines = 0;
    chatIdLabel.textColor = [UIColor whiteColor];
    chatIdLabel.text = @"Nickname: how users with a peek level smaller than your anonymity level will identify you.";
    [chatIdLabel sizeToFit];
    [self.view addSubview:chatIdLabel];
    
    verticalCount += chatIdLabel.frame.size.height + verticalSeparator;
    
    chatIdTextField = [[ChelseaTextField alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                                           verticalCount,
                                                                                          [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                                           50)];
    chatIdTextField.placeholder = @"Pandaman";
    chatIdTextField.delegate = self;
    chatIdTextField.layer.cornerRadius = 5.0f;
    [self.view addSubview:chatIdTextField];
    
    verticalCount += chatIdTextField.frame.size.height + verticalSeparator;
    
    realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                      verticalCount,
                                                                       [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                       10)];
    realNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    realNameLabel.numberOfLines = 0;
    realNameLabel.textColor = [UIColor whiteColor];
    realNameLabel.text = @"Real Name: for those with a higher peek level. Let's be playful!";
    [realNameLabel sizeToFit];
    [self.view addSubview:realNameLabel];
    
    verticalCount += realNameLabel.frame.size.height + verticalSeparator;
    
    realNameTextField = [[ChelseaTextField alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                                            verticalCount,
                                                                                            [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                                             50)];
    realNameTextField.delegate = self;
    realNameTextField.placeholder = @"Johnny Appleseed";
    realNameTextField.layer.cornerRadius = 5.0f;
    [self.view addSubview:realNameTextField];
    
    verticalCount += realNameTextField.frame.size.height + verticalSeparator;
    
    profilePictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                   verticalCount,
                                                                   [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                   10)];
    profilePictureLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    profilePictureLabel.numberOfLines = 0;
    profilePictureLabel.textColor = [UIColor whiteColor];
    profilePictureLabel.text = @"Your Picture: also for those with a higher peek level. We dare you.";
    [profilePictureLabel sizeToFit];
    
    [self.view addSubview:profilePictureLabel];

    verticalCount += profilePictureLabel.frame.size.height + verticalSeparator;
    
    profilePictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-[UIScreen mainScreen].bounds.size.width,
                                                                            verticalCount,
                                                                           [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                            150)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [profilePictureImageView addGestureRecognizer:tapGestureRecognizer];
    profilePictureImageView.image = [UIImage imageNamed:@"profilePicturePlaceholder"];
    profilePictureImageView.contentMode = UIViewContentModeScaleAspectFit;
    profilePictureImageView.clipsToBounds = YES;
    profilePictureImageView.backgroundColor = [UIColor whiteColor];
    profilePictureImageView.layer.cornerRadius = 5.0f;
    profilePictureImageView.userInteractionEnabled = YES;
    [self.view addSubview:profilePictureImageView];
    
    verticalCount += profilePictureImageView.frame.size.height + verticalSeparator;
    
    playButtonTopMargin = verticalCount - 10.0f; // Special offset for this guy.
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin,
                                                                      [UIScreen mainScreen].bounds.size.height,
                                                                     [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                     75)];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f]];
    [playButton setTitle:@"Done here!" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:playButton];
}

- (void)tapped
{
    NSLog(@"Tapped picture. Should load camera.");
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) {
        return;
    }
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    // Default mediaType is images only, which is what we want.
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage, *editedImage, *imageToSave;
    editedImage = (UIImage *) [info objectForKey:
                               UIImagePickerControllerEditedImage];
    originalImage = (UIImage *) [info objectForKey:
                                 UIImagePickerControllerOriginalImage];
    
    if (editedImage) {
        imageToSave = editedImage;
    } else {
        imageToSave = originalImage;
    }
    
    NSLog(@"Original image size: %@", NSStringFromCGSize(imageToSave.size));
    // On iPhone 5S:
    //   in portrait: {2448, 3264}
    //   in landscape: {3264, 2448}
    
    CGSize newSize = profilePictureImageView.frame.size;
    UIGraphicsBeginImageContext(newSize);
    [imageToSave drawInRect:CGRectMake(0 , 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    profilePictureImageView.image = newImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.7f delay:1.0f usingSpringWithDamping:0.7f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
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
    
    [UIView animateWithDuration:0.7f delay:0.4f usingSpringWithDamping:0.7f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect headerViewFrame = headerView.frame;
        headerViewFrame.origin.y = headerViewTopMargin;
        headerView.frame = headerViewFrame;
    } completion:nil];
    
    [UIView animateWithDuration:0.7f delay:1.5f usingSpringWithDamping:0.7f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect playButtonFrame = playButton.frame;
        playButtonFrame.origin.y = playButtonTopMargin;
        playButton.frame = playButtonFrame;
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
