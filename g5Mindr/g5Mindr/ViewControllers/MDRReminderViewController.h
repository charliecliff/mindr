//
//  g5ReminderViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mindrBounceNavigationViewController.h"
#import "MDRReminder.h"

@interface MDRReminderViewController : UIViewController <HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@property(nonatomic, strong, readonly) MDRReminder *reminder;

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(MDRReminder *)reminder;

@end
