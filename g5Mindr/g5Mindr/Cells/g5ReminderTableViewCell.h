//
//  g5ReminderTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell/SWTableViewCell.h>
#import "MDRReminder.h"

@class MDRReminder;

@protocol g5ReminderCellDelegate <NSObject>

@required
- (void)g5Reminder:(MDRReminder *)condition didSetActive:(BOOL)active;

@end

@interface g5ReminderTableViewCell : SWTableViewCell

@property(nonatomic, strong, readonly) MDRReminder *reminder;
@property(nonatomic, strong) id<g5ReminderCellDelegate> reminderDelegate;

- (void)configureWithReminder:(MDRReminder *)reminder;

@end
