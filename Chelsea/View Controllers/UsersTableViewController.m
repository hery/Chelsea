//
//  UsersTableViewController.m
//  Chelsea
//
//  Created by pandaman on 5/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "UsersTableViewController.h"
#import "ProfileViewController.h"
#import "InAppPurchaseViewController.h"
#import "UserTableViewCell.h"

@interface UsersTableViewController ()

@end

@implementation UsersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"userCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(20, 0, 20, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData]; // Refresh upon updating Peek Level.
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger pLLevel = [[standardUserDefaults valueForKey:@"pl"] integerValue];
    UIBarButtonItem *pLLevelButton = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"PL-%li", pLLevel] style:UIBarButtonItemStylePlain target:self action:@selector(showinAppPurchases)];
    self.navigationItem.rightBarButtonItem = pLLevelButton;
}

- (void)didReceiveMemoryWarning
{       [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _users.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Users: %@", _users);
    UserTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    if (nil == cell) {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
    }
    cell.chatIdLabel.text = _users[indexPath.row][@"chatId"];
    cell.chatIdLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
    cell.chatIdLabel.textColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    NSDictionary *selectedUser = _users[indexPath.row];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger pLLevel = [[standardUserDefaults valueForKey:@"pl"] integerValue];
    NSInteger selectedUserAL = [(NSNumber *)selectedUser[@"userAL"] integerValue];
    cell.aLLevel.text = [NSString stringWithFormat:@"AL-%li", selectedUserAL];
    cell.aLLevel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    if (selectedUserAL <= pLLevel) {
        cell.aLLevel.textColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    } else {
        cell.aLLevel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *  Check for AL and PL level here from in-app purchases.
     *  If AL > PL: push in-app purchases view.
     *  Else (AL <= PL): view profile view.
     */
    
    NSDictionary *selectedUser = _users[indexPath.row];
    NSInteger selectedUserAL = [(NSNumber *)selectedUser[@"userAL"] integerValue];
    NSLog(@"The selected user has AL-%li.", (long)selectedUserAL);
    
    NSInteger PL = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pl"] integerValue];
    
    if (selectedUserAL > PL) {
        NSLog(@"AL-%li > PL-%li: Pushing In-App Purchases VC.", selectedUserAL, PL);
        InAppPurchaseViewController *inAppPurchaseViewController = [InAppPurchaseViewController new];
        inAppPurchaseViewController.inAppPurchaseType = InAppPurchaseTypeALPL;
        inAppPurchaseViewController.selectedUser = selectedUser;
        inAppPurchaseViewController.userAL = selectedUserAL;
        inAppPurchaseViewController.userPL = PL;
        [self.navigationController pushViewController:inAppPurchaseViewController animated:YES];
    } else {
        NSLog(@"AL-%li <= PL-%li: Pushing Profile VC.", selectedUserAL, PL);
        ProfileViewController *profileViewController = [ProfileViewController new];
        profileViewController.user = selectedUser;
        [self.navigationController pushViewController:profileViewController animated:YES];
    }
}

#pragma mark - Selectors

- (void)showinAppPurchases
{
    NSLog(@"Showing generic in-app purchases...");
    InAppPurchaseViewController *inAppPurchaseViewController = [InAppPurchaseViewController new];
    inAppPurchaseViewController.generic = YES;
    inAppPurchaseViewController.inAppPurchaseType = InAppPurchaseTypeALPL;
    [self.navigationController pushViewController:inAppPurchaseViewController animated:YES];
}


@end
