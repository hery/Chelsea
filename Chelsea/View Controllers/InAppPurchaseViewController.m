//
//  InAppPurchaseViewController.m
//  Chelsea
//
//  Created by pandaman on 5/29/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "InAppPurchaseViewController.h"
#import "InAppPurchaseTableViewCell.h"
#import "TransactionObserver.h"

#import "ProfileViewController.h"

@interface InAppPurchaseViewController ()

@end

@implementation InAppPurchaseViewController

#pragma mark - App Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    self.title = @"In-App Purchases";
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[InAppPurchaseTableViewCell class] forCellReuseIdentifier:@"itemCell"];
    
    switch (_inAppPurchaseType) {
        case InAppPurchaseTypeALPL:
        {
            NSLog(@"Loading AL and PL purchase view...");
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"inAppPurchasesALPL"
                                                 withExtension:@"plist"];
            NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];
            [self validateProductIdentifiers:productIdentifiers];
            break;
        }
            
        default:
            break;
    }
    
    TransactionObserver *transactionObserver = [TransactionObserver sharedTransactionObserver];
    transactionObserver.aLpLViewController = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"AL,PL = %li, %li", _userAL, _userPL);
    if (_userAL > _userPL) {
        
        self.tableView.userInteractionEnabled = YES;
        
        NSString *insufficientLevelMessageString;
        if (_userAL == 3) {
            insufficientLevelMessageString = @"This user is anonymous (AL-3)."; }
        else {
            insufficientLevelMessageString = [NSString stringWithFormat:@"You cannot view this user's profile, because your Peek Level (PL) is too low. Since this user is AL-%li, you need to be at least PL-%li.", (long)_userAL, (long)_userAL];
        }
        
        [[[UIAlertView alloc] initWithTitle:@"Whoops!"
                                    message:insufficientLevelMessageString
                                   delegate:self
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    } else if (_generic) {} else                                {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InAppPurchaseTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    
    if (itemCell == nil) {
        itemCell = [[InAppPurchaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"];
    }

    SKProduct *product = _products[indexPath.row];
    
    itemCell.titleLabel.text = [product localizedTitle];
    itemCell.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:23.0f];
    // todo: use text kit to make text size flexible
    // (con) multiple text size could be confusing
    itemCell.titleLabel.textColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    
    itemCell.subtitleLabel.text = product.localizedDescription;
    itemCell.subtitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    itemCell.subtitleLabel.textColor = [UIColor blackColor];

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
    itemCell.priceLabel.text = formattedPrice;
    itemCell.priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
    itemCell.priceLabel.textColor = [UIColor blackColor];
    
    NSLog(@"Setting up in-app purchase:");
    NSLog(@"    Title: %@", [product localizedTitle]);
    NSLog(@"    Description: %@", [product localizedDescription]);
    NSLog(@"    Price: %@", formattedPrice);
    NSLog(@"----");
    
    return itemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.userInteractionEnabled = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:_products[indexPath.row]];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - Store Kit

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    NSLog(@"Validating products identifiers: <%@>", productIdentifiers);
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    NSLog(@"Got Store Kit products: %@", self.products);
    [self.tableView reloadData];
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"Invalid product: %@", invalidIdentifier);
    }
}

#pragma mark - Instance Methods

- (void)completedPurchaseForLevelWithTransaction:(SKPaymentTransaction *)transaction
{
    // todo: validate receipt data with App Store
    
    NSString *transactionProductID = transaction.payment.productIdentifier;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"inAppPurchasesALPL"
                                         withExtension:@"plist"];
    NSArray *productIdentifiers = [NSArray arrayWithContentsOfURL:url];
    NSUInteger productIndex = [productIdentifiers indexOfObject:transactionProductID];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSString *feedbackString;

    NSInteger previousPL = [[standardDefaults valueForKey:@"pl"] integerValue];
    NSInteger newPL = 0;
    NSInteger previousAL = [[standardDefaults valueForKey:@"al"] integerValue];
    NSInteger newAL = 0;
    
    switch (productIndex) {
        case 0: // AL-1
        {
            feedbackString = @"Anonymity Level 1 (AL-1) acquired!";
            NSLog(@"Anonymity Level 1 (AL-1) acquired! Please exit the venue and check-in again to apply it.");
            newAL = 1;
            break;
        }
        case 1: // AL-2
        {
            feedbackString = @"Anonymity Level 2 (AL-2) acquired! Please exit the venue and check-in again to apply it.";
            NSLog(@"Anonymity Level 2 (AL-2) acquired!");
            newAL = 2;
            break;
        }
        case 2: // AL-3
        {
            feedbackString = @"Anonymity Level 3 (AL-3) acquired! You've obtained complete anonymity.";
            NSLog(@"Anonymity Level 3 (AL-3) acquired!");
            newAL = 3;
            break;
        }
        case 3: // PL-1
        {
            feedbackString = @"Peek Level 1 (PL-1) acquired!";
            NSLog(@"Peek Level 1 (PL-1) acquired!");
            newPL = 1;

            break;
        }
        case 4: // PL -2
        {
            feedbackString = @"Peek Level 2 (PL-2) acquired!";
            NSLog(@"Peek Level 2 (AL-2) acquired!");
            newPL = 2;
            break;
        }
            
        default:
            break;
    }
    
    if (previousPL < newPL && productIndex >= 3) {
        [standardDefaults setValue:[NSNumber numberWithInteger:newPL] forKey:@"pl"];
        _userPL = newPL;
    } else if (previousAL < newAL && productIndex < 3) {
        [standardDefaults setValue:[NSNumber numberWithInteger:newAL] forKey:@"al"];
    }
    
    if (!_generic) {
        ProfileViewController *profileViewController = [ProfileViewController new];
        profileViewController.user = _selectedUser;
        [self.navigationController pushViewController:profileViewController animated:YES];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Woot!" message:feedbackString delegate:self cancelButtonTitle:@"All right!" otherButtonTitles:nil] show];
    }
    
    _tableView.userInteractionEnabled = YES;
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    self.tableView.userInteractionEnabled = YES;
}

@end
