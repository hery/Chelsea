//
//  HomeViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString *fourSquareAccessCodeString;
}


- (void)handleAuthenticationForURL:(NSURL *)url;

@end
