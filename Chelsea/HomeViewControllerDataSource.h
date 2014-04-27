//
//  HomeViewControllerDataSource.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/28/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface HomeViewControllerDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *venuesArray;
@property (nonatomic, assign) CLLocationDegrees currentLatitude;
@property (nonatomic, assign) CLLocationDegrees currentLongitude;

@end
