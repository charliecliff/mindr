#import "AppDelegate.h"
#import "g5ReminderManager.h"

#import "MDREmoticonSelectionViewController.h"

#import "mindrBounceNavigationViewController.h"
#import "MDRReminderListViewController.h"


#import "g5ReminderManager.h"
#import "MDRLocationManager.h"
#import "MDRUserManager.h"

#import <Google/Analytics.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //  Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
        application.applicationIconBadgeNumber = 0;
    }
    
    //  External APIs
    [GMSServices provideAPIKey:@"AIzaSyB3OXTo9OFaMhK1MIyNqFa98W8lyPA6Pn8"];
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    //  Background fetching
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    //  Managers
    [[g5ReminderManager sharedManager] loadReminders];
    [[MDRLocationManager sharedManager] startUpdatingLocation];
    [[MDRUserManager sharedManager] bindToLocationManager:[MDRLocationManager sharedManager]];
    
    //  Register For Push Notifications
    if ([MDRUserManager sharedManager].currentUserContext.userID == nil) {
        [self registerForPushNotifications];
    }
    
    //  Root View Controller
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
    [[g5ReminderManager sharedManager] saveReminders];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[g5ReminderManager sharedManager] loadReminders];
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
    [[MDRUserManager sharedManager] setUserID:token];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

@end
