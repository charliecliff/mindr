//
//  AppDelegate.m
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "g5MenuSourceAsset.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ViewController *sceneVC = [[ViewController alloc] init];
    sceneVC.menuSource = [[g5MenuSourceAsset alloc] init];
    
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:sceneVC];
    [vc setNavigationBarHidden:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
