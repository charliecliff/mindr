//
//  g5ReminderExplanationViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class g5Reminder;
@class HROBounceNavigationController;

@interface g5ReminderExplanationViewController : UIViewController

@property(nonatomic, strong) g5Reminder *reminder;

@property(nonatomic, weak) HROBounceNavigationController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
