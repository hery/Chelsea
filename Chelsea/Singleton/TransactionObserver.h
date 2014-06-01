//
//  TransactionObserver.h
//  Chelsea
//
//  Created by pandaman on 5/31/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@class InAppPurchaseViewController;

@interface TransactionObserver : NSObject <SKPaymentTransactionObserver>

@property (nonatomic, strong) InAppPurchaseViewController *aLpLViewController;

+ (TransactionObserver *)sharedTransactionObserver;

@end
