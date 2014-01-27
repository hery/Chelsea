//
//  HomeViewController.h
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> 

@property (strong, nonatomic) NSString *fourSquareAccessCodeString;
@property (weak, nonatomic) IBOutlet UISearchBar *venueSearchBar;

- (void)handleAuthenticationForURL:(NSURL *)url;

/**
 Parse the query string into a dictionary.
 Todo: move to a utility class.
 */
- (NSDictionary *)parseQueryString:(NSString *)queryString;
- (void)searchVenuesForQueryString:(NSString *)queryString;

@end
