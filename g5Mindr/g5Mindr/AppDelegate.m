//
//  AppDelegate.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "AppDelegate.h"
#import "g5ReminderManager.h"

#import "g5EmoticonSelectionViewController.h"
#import "g5ReminderListViewController.h"

#import "g5WeatherMonitor.h"

#import "g5ReminderManager.h"
#import "g5LocationManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    
    [[g5ReminderManager sharedManager] loadReminders];
    [[g5LocationManager sharedManager] startUpdatingLocation];
    
    
    g5ReminderListViewController *vc = [[g5ReminderListViewController alloc] init];
//    g5EmoticonSelectionViewController *vc = [[g5EmoticonSelectionViewController alloc] init];
    
    UINavigationController *baseNavigationViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [baseNavigationViewController setNavigationBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = baseNavigationViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[g5ReminderManager sharedManager] updateReminders];
    
    if (completionHandler) {
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[g5ReminderManager sharedManager] saveReminders];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[g5ReminderManager sharedManager] loadReminders];
}

@end
