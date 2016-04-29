//
//  g5ReminderTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5Reminder.h"

@class g5Reminder;

@protocol g5ReminderCellDelegate <NSObject>

@required
- (void)g5Reminder:(g5Reminder *)condition didSetActive:(BOOL)active;

@end

@interface g5ReminderTableViewCell : UITableViewCell

@property(nonatomic, strong, readonly) g5Reminder *reminder;
@property(nonatomic, strong) id<g5ReminderCellDelegate> delegate;

- (void)configureWithReminder:(g5Reminder *)reminder;

@end
