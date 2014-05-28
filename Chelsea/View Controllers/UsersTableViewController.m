//
//  UsersTableViewController.m
//  Chelsea
//
//  Created by pandaman on 5/16/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "UsersTableViewController.h"
#import "ProfileViewController.h"

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userCell"];
    self.tableView.separatorInset = UIEdgeInsetsMake(20, 0, 20, 0);
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
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    cell.textLabel.text = _users[indexPath.row][@"chatId"];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:28.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    selectedCell.textLabel.textColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProfileViewController *profileViewController = [ProfileViewController new];
    profileViewController.user = _users[indexPath.row];
    [self.navigationController pushViewController:profileViewController animated:YES];
}

#pragma mark - Table view delegate


@end
