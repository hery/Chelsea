//
//  ProfileSetupViewController.h
//  Chelsea
//
//  Created by pandaman on 7/26/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChelseaTextField;

@interface ProfileSetupViewController : UIViewController <UITextFieldDelegate,
                                                            UIImagePickerControllerDelegate,
                                                            UINavigationControllerDelegate,
                                                            UIScrollViewDelegate> {
    UILabel *chatIdLabel;
    ChelseaTextField *chatIdTextField;
    UILabel *realNameLabel;
    ChelseaTextField *realNameTextField;
    UILabel *profilePictureLabel;
    UIImageView *profilePictureImageView;
    UIView *headerView;
    UIButton *playButton;
    UIAlertView *doneAlertView;
    
    CGFloat headerViewTopMargin;
    CGFloat playButtonTopMargin;
                                                                
    NSInteger numberOfPages;
}

@end
