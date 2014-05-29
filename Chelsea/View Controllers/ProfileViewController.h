//
//  ProfileViewController.h
//  Chelsea
//
//  Created by pandaman on 5/28/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) NSDictionary *user;
@property (nonatomic, strong) UIImageView *profilePicture;

@property (nonatomic, assign) NSUInteger AL;
@property (nonatomic, assign) NSUInteger PL;

@end
