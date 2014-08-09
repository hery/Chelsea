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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = _user[@"chatId"];
    NSLog(@"Current user: %@", _user);
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0]}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    static const CGFloat profilePictureRadius = 250;

    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, profilePictureRadius, profilePictureRadius)];
    _profilePicture.center = self.view.center;
    
    static const CGFloat profilePictureOffset = 50.0f;
    CGRect adjustedFrameForProfilePicture = _profilePicture.frame;
    adjustedFrameForProfilePicture.origin.y -= profilePictureOffset;
    _profilePicture.frame = adjustedFrameForProfilePicture;
    _profilePicture.backgroundColor = [UIColor whiteColor];
        
    [self.view addSubview:_profilePicture];
    
    UILabel *realNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    realNameLabel.center = _profilePicture.center;
    
    CGRect adjustFrameForRealNameLabel = realNameLabel.frame;
    adjustFrameForRealNameLabel.origin.y += _profilePicture.frame.size.height/2 + 50; // 30 = margin
    realNameLabel.frame = adjustFrameForRealNameLabel;
    
    realNameLabel.text = _user[@"realName"] ?: @"Stranger";
    realNameLabel.backgroundColor = [UIColor whiteColor];
    realNameLabel.textColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    realNameLabel.textAlignment = NSTextAlignmentCenter;
    realNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
    [self.view addSubview:realNameLabel];
    
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/checkchat/profilePictures/%@.png", _user[@"user"][@"id"]]];
    _profilePicture.contentMode = UIViewContentModeCenter;
    [_profilePicture sd_setImageWithURL:imageURL];
//    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:imageURL];
//    manager.responseSerializer = [AFImageResponseSerializer serializer];
//    NSString *urlString = [NSString stringWithFormat:@"%@.png", _user[@"user"][@"id"]];
//    [manager GET:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        UIImage *profilePicture = responseObject;
//        
//        static UIImage *maskImage = nil;
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            
//            UIGraphicsBeginImageContextWithOptions(CGSizeMake(profilePictureRadius, profilePictureRadius), NO, 0.0f);
//            CGContextRef ctx = UIGraphicsGetCurrentContext();
//            CGContextSaveGState(ctx);
//            
//            CGRect rect = CGRectMake(0, 0, profilePictureRadius, profilePictureRadius);
//            CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
//            CGContextFillRect(ctx, rect);
//            
//            CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
//            CGContextFillEllipseInRect(ctx, rect);
//            
//            CGContextRestoreGState(ctx);
//            maskImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//        });
//        
//        CGImageRef imageReference = profilePicture.CGImage;
//        CGImageRef maskReference = maskImage.CGImage;
//        
//        CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
//                                                 CGImageGetHeight(maskReference),
//                                                 CGImageGetBitsPerComponent(maskReference),
//                                                 CGImageGetBitsPerPixel(maskReference),
//                                                 CGImageGetBytesPerRow(maskReference),
//                                                 CGImageGetDataProvider(maskReference),
//                                                 NULL, // Decode is null
//                                                 NO // Should interpolate
//                                                 );
//        
//        CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
//        CGImageRelease(imageMask);
//        
//        UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
//        CGImageRelease(maskedReference);
//        
//        _profilePicture.image = maskedImage;
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"Couldn't get profile picture.");
//        NSLog(@"Request URL: %@", task.response.URL);
//    }];
    
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
