//
//  InAppPurchaseViewController.h
//  Chelsea
//
//  Created by pandaman on 5/29/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger, InAppPurchaseType) {
    InAppPurchaseTypeALPL
};

@interface InAppPurchaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SKProductsRequestDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) InAppPurchaseType inAppPurchaseType;
@property (nonatomic, strong) NSArray *purchaseItemsArray;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger userAL;
@property (nonatomic, assign) NSInteger userPL;

@end
