//
//  HomeViewControllerDataSource.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/28/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "HomeViewControllerDataSource.h"

@implementation HomeViewControllerDataSource

- (id)init {
    self = [super init];
    if (self) {
        self.venuesArray = [[NSMutableArray alloc] initWithObjects:nil];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_venuesArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if ([_venuesArray count] > 0)
        cell.textLabel.text = _venuesArray[indexPath.row][@"name"];
    else
        cell.textLabel.text = @"nil";
    return cell;
}

@end
