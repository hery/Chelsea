//
//  TransactionObserver.m
//  Chelsea
//
//  Created by pandaman on 5/31/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "TransactionObserver.h"

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
                NSLog(@"Completed purchase for %@", transaction.payment.productIdentifier);
                break;
            }
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"Transaction failed for %@", transaction.payment.productIdentifier);
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
