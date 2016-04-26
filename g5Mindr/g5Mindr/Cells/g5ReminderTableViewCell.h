//
//  g5ReminderTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5Reminder.h"

@interface g5ReminderTableViewCell : UITableViewCell

@property(nonatomic, strong, readonly) g5Reminder *reminder;

- (void)configureWithReminder:(g5Reminder *)reminder;

@end
