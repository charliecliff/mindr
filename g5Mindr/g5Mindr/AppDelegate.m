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


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [g5ReminderManager sharedManager];
    
    g5ReminderListViewController *vc = [[g5ReminderListViewController alloc] init];
//    g5EmoticonSelectionViewController *vc = [[g5EmoticonSelectionViewController alloc] init];
    
    UINavigationController *baseNavigationViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    [baseNavigationViewController setNavigationBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = baseNavigationViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
