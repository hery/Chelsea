//
//  InAppPurchaseViewController.h
//  Chelsea
//
//  Created by pandaman on 5/29/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, InAppPurchaseType) {
    InAppPurchaseTypeALPL
};

@interface InAppPurchaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) InAppPurchaseType inAppPurchaseType;

@end
