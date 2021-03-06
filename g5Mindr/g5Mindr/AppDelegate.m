#import "AppDelegate.h"
#import "g5ReminderManager.h"

#import "MDREmoticonSelectionViewController.h"

#import "mindrBounceNavigationViewController.h"
#import "MDRReminderListViewController.h"


#import "g5ReminderManager.h"
#import "MDRUserManager.h"

#import <Google/Analytics.h>
#import <GoogleMaps/GoogleMaps.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
  didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
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
//    [[MDRLocationManager sharedManager] startUpdatingLocation];
//    [[MDRUserManager sharedManager] bindToLocationManager:[MDRLocationManager sharedManager]];
  
    NSString *userID = [MDRUserManager sharedManager].currentUserContext.userID;
    //  Register For Push Notifications
    if (userID == nil || [userID isEqualToString:@"simulator_id"]){
        [self registerForPushNotifications];
    }
    
    //  Root View Controller
    UIStoryboard *sbReminderList = [UIStoryboard storyboardWithName:@"MDRReminderList" bundle:nil];
    MDRReminderListViewController *vc = [sbReminderList instantiateInitialViewController];
    mindrBounceNavigationViewController *bounceVC = [[mindrBounceNavigationViewController alloc] initWithRootViewController:vc
                                                                                                               withDelegate:vc
                                                                                                             withDatasource:nil];
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
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  [[g5ReminderManager sharedManager] loadReminders];
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application
  didReceiveRemoteNotification:(NSDictionary *)userInfo
  fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler {
  
  NSLog(@"fetchCompletionHandler");
  
  handler(UIBackgroundFetchResultNewData);
}


- (void)registerForPushNotifications {
    UIUserNotificationType types = (UIUserNotificationType) (UIUserNotificationTypeBadge |
                                                             UIUserNotificationTypeSound |
                                                             UIUserNotificationTypeAlert);
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types
                                                                               categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

- (void)application:(UIApplication *)application
  didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings {
    UIApplication *app = [UIApplication sharedApplication];
    BOOL test = [app respondsToSelector:@selector(registerForRemoteNotifications)];
    if (test) {
      [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application
  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[MDRUserManager sharedManager] setUserID:token];
    [[MDRUserManager sharedManager] updateContext];
}

- (void)application:(UIApplication *)app
  didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}

@end
