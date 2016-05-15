//
//  g5ReminderViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mindrBounceNavigationViewController.h"
#import "g5Reminder.h"

@interface g5ReminderViewController : UIViewController <HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@property(nonatomic, strong, readonly) g5Reminder *reminder;

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
