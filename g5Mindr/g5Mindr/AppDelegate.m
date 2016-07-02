//
//  AppDelegate.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "AppDelegate.h"
#import "MDRReminderManager.h"

#import "g5EmoticonSelectionViewController.h"

#import "mindrBounceNavigationViewController.h"
#import "MDRReminderListViewController.h"


#import "MDRReminderManager.h"
#import "MDRLocationManager.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //  1. Register For Push Notifications
    [self registerForPushNotifications];

    //  2. Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
    }
    
    //  5. External APIs
    [GMSServices provideAPIKey:@"AIzaSyB3OXTo9OFaMhK1MIyNqFa98W8lyPA6Pn8"];
    
    //  3. Background fetching
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //  4. Managers
    [[MDRReminderManager sharedManager] loadReminders];
    [[MDRLocationManager sharedManager] startUpdatingLocation];
    
    //  6. Root View Controller
    UIStoryboard *sbReminderList = [UIStoryboard storyboardWithName:@"MDRReminderList" bundle:nil];
    MDRReminderListViewController *vc = [sbReminderList instantiateInitialViewController];
    mindrBounceNavigationViewController *bounceVC = [[mindrBounceNavigationViewController alloc] initWithRootViewController:vc withDelegate:vc withDatasource:nil];
    bounceVC.datasource = bounceVC;
    
    vc.bounceNavigationController = bounceVC;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = bounceVC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[MDRReminderManager sharedManager] saveReminders];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[MDRReminderManager sharedManager] loadReminders];
}

#pragma mark - Push Notifications

- (void)registerForPushNotifications {
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert);
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![MDRReminderManager sharedManager].userContext.userID) {
        [[MDRReminderManager sharedManager] setUserID:token];
    }
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

@end
