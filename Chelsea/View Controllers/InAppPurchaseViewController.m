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
            NSLog(@"Loading AL and PL purchase view...");
            // Let's populate the table view with hard-coded data for now.
            // todo: get items from in-app purchases.
            _purchaseItemsArray = @[@"PL-1", @"PL-2", @"AL-1", @"AL-2", @"AL-3"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _purchaseItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"itemCell" forIndexPath:indexPath];
    itemCell.textLabel.text = _purchaseItemsArray[indexPath.row];
    return itemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
