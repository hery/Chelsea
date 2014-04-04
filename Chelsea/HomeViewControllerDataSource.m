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
        self.venueNameArray = [[NSMutableArray alloc] initWithObjects:nil];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [_venueNameArray count];
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CoffeeCell" forIndexPath:indexPath];
    if ([_venueNameArray count] > 0)
        cell.textLabel.text = _venueNameArray[indexPath.row];
    return cell;
}

@end
