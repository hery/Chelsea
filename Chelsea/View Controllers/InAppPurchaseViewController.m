//
//  InAppPurchaseViewController.m
//  Chelsea
//
//  Created by pandaman on 5/29/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "InAppPurchaseViewController.h"

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"itemCell"];
    
    switch (_inAppPurchaseType) {
        case InAppPurchaseTypeALPL:
        {
            _purchaseItemsArray = @[@"Anonymity Level 1 (AL-1)"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _purchaseItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    if (!itemCell) {
        itemCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"itemCell"];
    }
    itemCell.textLabel.text = _purchaseItemsArray[indexPath.row];
    itemCell.detailTextLabel.text = @"$0.99";
    return itemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        // Handle any invalid product identifiers.
        NSLog(@"Invalid product: %@", invalidIdentifier);
    }
    
}

@end
