//
//  g5ReminderViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class g5Reminder;

@protocol g5ReminderViewControllerDelegate <NSObject>

@required
- (void)didSelectConditionCell;

@end

@interface g5ReminderViewController : UITableViewController

@property(nonatomic, strong) g5Reminder *reminder;
@property(nonatomic, strong) id<g5ReminderViewControllerDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
