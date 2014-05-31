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


@end
