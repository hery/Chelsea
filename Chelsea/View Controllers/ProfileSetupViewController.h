//
//  ProfileSetupViewController.h
//  Chelsea
//
//  Created by pandaman on 7/26/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChelseaTextField;

@interface ProfileSetupViewController : UIViewController <UITextFieldDelegate> {
    UILabel *chatIdLabel;
    ChelseaTextField *chatIdTextField;
    UILabel *realNameLabel;
    ChelseaTextField *realNameTextField;
    UILabel *profilePictureLabel;
    UIImageView *profilePictureImageView;
}

@end
