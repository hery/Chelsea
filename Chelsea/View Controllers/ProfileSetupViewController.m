//
//  ProfileSetupViewController.m
//  Chelsea
//
//  Created by pandaman on 7/26/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "ProfileSetupViewController.h"
#import "FoursquareHTTPClient.h"
#import "FoursquareHTTPClientDelegate.h"
#import "ChelseaTextField.h"
#import "ChelseaHTTPClient.h"
#import "constants.h"

#import <ONOXMLDocument.h>
#import <AFAmazonS3Manager.h>
#import <AFOnoResponseSerializer.h>

static const CGFloat topMargin = 30.0f;
static const CGFloat leftMargin = 10.0f;
static const CGFloat verticalSeparator = 10.0f;

@interface ProfileSetupViewController ()

@end

@implementation ProfileSetupViewController

#pragma mark - View Controller Lifecycle

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
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSArray *dataSourceMessage = @[@"",
                                   @"CheckChat is a location-based chat app that uses a playful anonymity system to kindle your encounters and give you a chance to financially help us keep the wheel turning.",
                                   @"By default, everyone in CheckChat is anonymous. You only see usernames. \n\rHowever, anonymity and peek levels (AL and PL) make it possible to break the anonymity wall.",
                                   @"A user with a peek level that is higher than another user’s anonymity level can see the real identify of that user. \n\rHigher anonymity and peek levels are available as in-app purchases. We use the money to keep the service running. And for coffee, if any is left.",
                                   @"By giving us your username, you agree to let us share it with everyone.\n\rBy giving us your real name and profile picture, you agree to let us share them with users with a higher peek level than your peek level.\n\rLet’s get started!"];
    
    NSArray *boldStringsArray = @[@[@""],
                                  @[@"CheckChat"],
                                  @[@"everyone in CheckChat is anonymous"],
                                  @[@"peek level", @"higher", @"anonymity level", @"in-app purchases", @"coffee"],
                                  @[@"username", @"everyone", @"real name and profile picture", @"users with a higher peek level"]];
    
    numberOfPages = dataSourceMessage.count + 1;
    
    NSLog(@"Loaded profile setup view view controller.");
    CGFloat verticalCount = topMargin;
    
    NSLog(@"Fetching Foursquare id...");
    FoursquareHTTPClient *sharedFSClient = [FoursquareHTTPClient sharedFoursquareHTTPClient];
    sharedFSClient.delegate = [FoursquareHTTPClientDelegate new];
    [sharedFSClient performGETRequestForEndpointString:@"users/self" endpointConstant:FoursquareHTTPClientEndpointMe additionalParameters:nil];
    
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
    
    profileSetupScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                                          verticalCount,
                                                                                          [UIScreen mainScreen].bounds.size.width,
                                                                                          [UIScreen mainScreen].bounds.size.height - headerView.frame.size.height)];
    profileSetupScrollView.delegate = self;
    profileSetupScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * numberOfPages, profileSetupScrollView.frame.size.height);
    profileSetupScrollView.pagingEnabled = YES;
    profileSetupScrollView.backgroundColor = profileSetupScrollView.superview.backgroundColor;
    [self.view addSubview:profileSetupScrollView];
    
    UIImageView *splashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    splashImageView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds),
                                         CGRectGetMidY([UIScreen mainScreen].bounds) - profileSetupScrollView.frame.origin.y);
    splashImageView.image = [UIImage imageNamed:@"logo"];
    splashImageView.contentMode = UIViewContentModeScaleAspectFit;
    splashImageView.clipsToBounds = YES;
    [profileSetupScrollView addSubview:splashImageView];
    
    verticalCount = 0;
    static int currentPageIndex = 0;

    for (int i = currentPageIndex; i < numberOfPages-1; i++) {
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*i,
                                                                              verticalCount,
                                                                              [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                              10.0f)];
        UIFont *boldFontName = [UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0f];
        NSString *messageString = dataSourceMessage[i];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:messageString];
        [attrString beginEditing];

        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont fontWithName:@"HelveticaNeue-Thin" size:22.0f]
                           range:NSMakeRange(0, messageString.length)];
        
        for (NSString *subString in boldStringsArray[i]) {
            NSRange boldedRange = [messageString rangeOfString:subString];
            [attrString addAttribute:NSFontAttributeName
                               value:boldFontName
                               range:boldedRange];
        }

        [attrString endEditing];
        
        descriptionLabel.attributedText = attrString;
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.textColor = [UIColor whiteColor];
        [descriptionLabel sizeToFit];
        
        CGPoint labelCenter = descriptionLabel.center;
        labelCenter.y = CGRectGetMidY([UIScreen mainScreen].bounds) - profileSetupScrollView.frame.origin.y;
        descriptionLabel.center = labelCenter;
        
        [profileSetupScrollView addSubview:descriptionLabel];
    }
    
    currentPageIndex = numberOfPages - 1;
    verticalCount = 0;
    
    chatIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                             verticalCount,
                                                             [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                             10)];
    chatIdLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    chatIdLabel.numberOfLines = 0;
    chatIdLabel.textColor = [UIColor whiteColor];
    chatIdLabel.text = @"Username – How everybody will see you.";
    [chatIdLabel sizeToFit];
    [profileSetupScrollView addSubview:chatIdLabel];
    
    verticalCount += chatIdLabel.frame.size.height + verticalSeparator;
    
    chatIdTextField = [[ChelseaTextField alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                                           verticalCount,
                                                                          [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                           50)];
    chatIdTextField.placeholder = @"Pandaman";
    chatIdTextField.delegate = self;
    chatIdTextField.layer.cornerRadius = 5.0f;
    [profileSetupScrollView addSubview:chatIdTextField];
    
    verticalCount += chatIdTextField.frame.size.height + verticalSeparator;
    
    realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                              verticalCount,
                                                               [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                               10)];
    realNameLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    realNameLabel.numberOfLines = 0;
    realNameLabel.textColor = [UIColor whiteColor];
    realNameLabel.text = @"Real Name – For those with a higher peek level.";
    [realNameLabel sizeToFit];
    [profileSetupScrollView addSubview:realNameLabel];
    
    verticalCount += realNameLabel.frame.size.height + verticalSeparator;
    
    realNameTextField = [[ChelseaTextField alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                                            verticalCount,
                                                                            [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                             50)];
    realNameTextField.delegate = self;
    realNameTextField.placeholder = @"Johnny Appleseed";
    realNameTextField.layer.cornerRadius = 5.0f;
    [profileSetupScrollView addSubview:realNameTextField];
    
    verticalCount += realNameTextField.frame.size.height + verticalSeparator;
    
    profilePictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                                   verticalCount,
                                                                   [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                   10)];
    profilePictureLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    profilePictureLabel.numberOfLines = 0;
    profilePictureLabel.textColor = [UIColor whiteColor];
    profilePictureLabel.text = @"Picture – Also for those with a higher peek level. Tap the picture below and be playful!";
    [profilePictureLabel sizeToFit];
    
    [profileSetupScrollView addSubview:profilePictureLabel];

    verticalCount += profilePictureLabel.frame.size.height + verticalSeparator;
    
    profilePictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                                            verticalCount,
                                                                           [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                            150)];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [profilePictureImageView addGestureRecognizer:tapGestureRecognizer];
    profilePictureImageView.image = [UIImage imageNamed:@"profilePicturePlaceholder"];
    profilePictureImageView.contentMode = UIViewContentModeCenter;
    profilePictureImageView.clipsToBounds = YES;
    profilePictureImageView.backgroundColor = [UIColor whiteColor];
    profilePictureImageView.layer.cornerRadius = 5.0f;
    profilePictureImageView.userInteractionEnabled = YES;
    [profileSetupScrollView addSubview:profilePictureImageView];
    
    verticalCount += profilePictureImageView.frame.size.height + verticalSeparator;
    
    playButtonTopMargin = verticalCount - 10.0f; // Special offset for this guy.
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin + screenWidth*currentPageIndex,
                                                                      playButtonTopMargin,
                                                                     [UIScreen mainScreen].bounds.size.width - 2*leftMargin,
                                                                     75)];
    playButton.backgroundColor = [UIColor clearColor];
    [playButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f]];
    [playButton setTitle:@"Done here!" forState:UIControlStateNormal];
    [playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(doneHere) forControlEvents:UIControlEventTouchUpInside];
    [profileSetupScrollView addSubview:playButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        profileSetupScrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    } completion:nil];
    NSLog(@"Current foursquare id: %@", [[NSUserDefaults standardUserDefaults] valueForKey:@"foursquareId"]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

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

- (void)doneHere
{
    NSString *chatIdString = chatIdTextField.text;
    NSString *realNameString = realNameTextField.text;
    UIImage *profilePicture = profilePictureImageView.image;
    NSString *foursquareIdString = [[NSUserDefaults standardUserDefaults] valueForKey:@"foursquareId"];
    NSLog(@"Hi %@! Or rather... %@. I've got your profile picture there %@, and I'll save it as %@.", chatIdString, realNameString, profilePicture, foursquareIdString);

    // Save image to Amazon S3. Save URL for user dictionary.
    NSData *pngImage = UIImagePNGRepresentation(profilePicture);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", foursquareIdString]];
    
    if (![chatIdString isEqualToString:@""] && ![realNameString isEqualToString:@""] && !([chatIdString length] > 16)) {
        
        // Check chatId string uniqueness
        doneAlertView = [[UIAlertView alloc] initWithTitle:@"Please Wait" message:@"We're setting you up. This is going to be awesome!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [doneAlertView show];
        
        ChelseaHTTPClient *sharedChelseaHTTPClient = [ChelseaHTTPClient sharedChelseaHTTPClient];
        NSDictionary *parameters = @{@"chatId": chatIdString,
                                     @"realName": realNameString};
        [sharedChelseaHTTPClient POST:@"/setup" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            // Post chatId and realName.
            // Check for chatId uniqueness.
            // If unique, complete setup and return success.
            // On success, upload picture in background.
            // Picture name/URL should be a hash/encryption/whatever_makes_a_valid_name of chatId.
            NSLog(@"User setup successful. Response: %@", responseObject);
            [doneAlertView dismissWithClickedButtonIndex:0 animated:YES];
            NSLog(@"HTTP Response code: %li", [responseObject[@"code"] integerValue]);
            if ([responseObject[@"code"] integerValue] == 201) {
                
                // ## todo: set the user defaults BOOL key "setup" to YES
                
                if ([pngImage writeToFile:imagePath atomically:NO]) {
                    NSLog(@"Successfully cached profile picture to %@.", imagePath);
                    
                    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
                    [standardUserDefaults setValue:chatIdString forKeyPath:@"chatId"];
                    [standardUserDefaults setValue:realNameString forKeyPath:@"realName"];
                    
                    AFAmazonS3Manager *s3Manager = [[AFAmazonS3Manager alloc] initWithAccessKeyID:AWSAccessKeyId secret:AWSSecretKey];
                    s3Manager.responseSerializer = [AFOnoResponseSerializer XMLResponseSerializer];
                    s3Manager.requestSerializer.region = AFAmazonS3USStandardRegion;
                    s3Manager.requestSerializer.bucket = @"checkchat";
                    [s3Manager.requestSerializer setValue:@"image/png" forHTTPHeaderField:@"Content-Type"];
                    
                    NSString *pictureNameString = [NSString stringWithFormat:@"profilePictures/%@.png", foursquareIdString];
                    
                    [s3Manager putObjectWithFile:imagePath
                                 destinationPath:pictureNameString
                                      parameters:nil
                                        progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                                            NSLog(@"%f%% Uploaded", (totalBytesWritten / (totalBytesExpectedToWrite * 1.0f) * 100));
                                        } success:^(id responseObject) {
                                            NSLog(@"Successfully uploaded profile picture to Amazon S3.");
                                            NSLog(@"Response: %@", responseObject);
                                            // Save URL here
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"profileSetup"];
                                        } failure:^(NSError *error) {
                                            NSLog(@"Failed uploading profile picture to Amazon S3.");
                                            NSLog(@"Error: %@", [error localizedDescription]);
                                            [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"I could not save your picture. Check your internet connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                                        }];
                } else {
                    NSLog(@"Failed caching profile picture.");
                }
            } else if ([responseObject[@"code"] integerValue] == 409) {
                [[[UIAlertView alloc] initWithTitle:@"Uh Oh" message:@"Another user with this chat identifier already exists. Try something else!" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil] show];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"User setup error. %@", [error localizedDescription]);
            [doneAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [[[UIAlertView alloc] initWithTitle:@"Whoops" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil] show];
        }];
    } else  if ([chatIdString length] > 16) {
                [[[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Your nickname cannot be longer than 16 characters. Let's try that again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Whoops" message:@"Your nickname and real name cannot be empty. Let's try that again!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollingIndex = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    if (scrollingIndex > numberOfPages - 2) {
        CGFloat normalizedScrollingIndex = scrollingIndex - (numberOfPages - 2);
        CGRect headerViewFrame = headerView.frame;
        headerViewFrame.origin.y = -50 + 50*(1.5*normalizedScrollingIndex);
        headerView.frame = headerViewFrame;
    }
}

#pragma mark - Image Picker Delegate

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
    
    CGFloat scalingRatio = imageToSave.size.width / profilePictureImageView.frame.size.width;
    CGFloat newSizeWidth = imageToSave.size.width / scalingRatio;
    CGFloat newSizeHeight = imageToSave.size.height / scalingRatio;
    CGSize newSize = CGSizeMake(newSizeWidth, newSizeHeight);
    
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

#pragma mark - Textfield Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

@end
