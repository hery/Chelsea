//
//  TransactionObserver.m
//  Chelsea
//
//  Created by pandaman on 5/31/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "TransactionObserver.h"
#import "InAppPurchaseViewController.h"

@implementation TransactionObserver

+ (TransactionObserver *)sharedTransactionObserver
{
    static TransactionObserver *transactionObserver = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transactionObserver = [[self alloc] init];
    });
    return transactionObserver;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method.
            case SKPaymentTransactionStatePurchased:
            {
                NSURL *url = [[NSBundle mainBundle] URLForResource:@"inAppPurchasesALPL"
                                                     withExtension:@"plist"];
                NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];

                if ([productIdentifiers containsObject:transaction.payment.productIdentifier]) {
                    NSLog(@"Got AL/PL transaction.");
                }
                
                NSLog(@"Completed purchase for %@", transaction.payment.productIdentifier);
                [_aLpLViewController completedPurchaseForLevelWithTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"Transaction failed for %@", transaction.payment.productIdentifier);
                [_aLpLViewController failedTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"Restored transaction for %@", transaction.payment.productIdentifier);
                break;
            }
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads
{
    NSLog(@"Download state changed.");
}


@end
