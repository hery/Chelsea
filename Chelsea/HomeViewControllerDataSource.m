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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"venueCell"];
    }
    
    if ([_venuesArray count] > 0) {
        cell.textLabel.text = _venuesArray[indexPath.row][@"name"];
        
        NSString *addressString = _venuesArray[indexPath.row][@"location"][@"address"];
        
        if (addressString.length < 1)
            addressString = @"Near you";
        
        NSString *latitudeString = _venuesArray[indexPath.row][@"location"][@"lat"];
        NSString *longitudeString = _venuesArray[indexPath.row][@"location"][@"lng"];
        CGFloat lat = [latitudeString floatValue];
        CGFloat lng = [longitudeString floatValue];
        
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:_currentLatitude longitude:_currentLongitude];
        CLLocationDistance distanceToVenue = [venueLocation distanceFromLocation:userLocation];
        NSString *formattedDistanceString = [NSString stringWithFormat:@"%.01f", distanceToVenue];
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@m away)", addressString, formattedDistanceString];
    }
    else
        cell.textLabel.text = @"nil";
    return cell;
}

@end
