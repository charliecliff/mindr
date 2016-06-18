//
//  g5ReminderExplanationViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRReminder;
@class HROBounceNavigationController;

@interface g5ReminderExplanationViewController : UIViewController

@property(nonatomic, strong) MDRReminder *reminder;

@property(nonatomic, weak) HROBounceNavigationController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(MDRReminder *)reminder;

@end
