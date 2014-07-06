//
//  AppDelegate.m
//  Chelsea
//
//  Created by Hery Ratsimihah on 1/24/14.
//  Copyright (c) 2014 Hery Ratsimihah. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import <StoreKit/StoreKit.h>
#import "TransactionObserver.h"

NSString * const FoursquareApplicationName = @"com.naveenium.foursquare";

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:@"AA6a8c8c4a83167a48f12223b2035dfa6898f87afe"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor colorWithRed:44/255.0f green:114/225.0f blue:217/225.0f alpha:1.0];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UINavigationController *nav = [mainStoryBoard instantiateInitialViewController];
    
    HomeViewController *homeViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
    _loginViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
    
    
    NSUserDefaults *standardUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *foursquareAccessCodeString = [standardUserDefault objectForKey:@"foursquareAccessCode"];

    if (foursquareAccessCodeString) {
        [nav pushViewController:homeViewController animated:NO];
    } else {
        [nav pushViewController:_loginViewController animated:NO];
    }
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    TransactionObserver *observer = [TransactionObserver sharedTransactionObserver];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:observer];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url scheme] isEqualToString:@"chelsea"])
    {
        NSLog(@"Application delegate received request with URL: %@", url);
        [_loginViewController handleAuthenticationForURL:url];
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

@end
