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

#import "mindrBounceNavigationViewController.h"
#import "g5ReminderListViewController.h"

#import "g5WeatherMonitor.h"

#import "g5ReminderManager.h"
#import "g5LocationManager.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //  1. Register For Push Notifications
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];

    //  2. Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
    }
    
    //  3. Background fetching
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //  4. Managers
    [[g5ReminderManager sharedManager] loadReminders];
    [[g5LocationManager sharedManager] startUpdatingLocation];
    
    //  5. External APIs
    [GMSServices provideAPIKey:@"AIzaSyB3OXTo9OFaMhK1MIyNqFa98W8lyPA6Pn8"];
    
    //  6. Root View Controller
    g5ReminderListViewController *vc = [[g5ReminderListViewController alloc] init];
    mindrBounceNavigationViewController *bounceVC = [[mindrBounceNavigationViewController alloc] initWithRootViewController:vc withDelegate:vc withDatasource:nil];
    bounceVC.datasource = bounceVC;
    
    vc.bounceNavigationController = bounceVC;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = bounceVC;
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
