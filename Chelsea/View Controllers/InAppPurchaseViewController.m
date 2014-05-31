//
//  InAppPurchaseViewController.m
//  Chelsea
//
//  Created by pandaman on 5/29/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "InAppPurchaseViewController.h"
#import "InAppPurchaseTableViewCell.h"

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[UIAlertView alloc] initWithTitle:@"Whoops!"
                                message:[NSString stringWithFormat:@"You cannot view this user's profile, because your Peek Level (PL) is too low. Since this user is AL-%li, you need to be at least PL-%li.",
                                                    (long)_userAL, (long)_userAL]
                               delegate:self
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
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
        // Handle any invalid product identifiers.
        NSLog(@"Invalid product: %@", invalidIdentifier);
    }
    
}

@end
