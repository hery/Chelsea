//
//  HomeViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeViewControllerDataSource;

@interface HomeViewController : UIViewController <UITableViewDelegate, UISearchBarDelegate> {
    HomeViewControllerDataSource *dataSource;
    
}

@property (weak, nonatomic) IBOutlet UISearchBar *venueSearchBar;
@property (weak, nonatomic) IBOutlet UITableView *venueTableView;

- (void)handleAuthenticationForURL:(NSURL *)url;
- (void)searchVenuesForQueryString:(NSString *)queryString;

@end
