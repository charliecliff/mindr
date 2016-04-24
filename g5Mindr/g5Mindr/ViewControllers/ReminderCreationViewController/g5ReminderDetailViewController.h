//
//  g5ReminderDetailViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5Reminder.h"

@interface g5ReminderDetailViewController : UIViewController

@property(nonatomic, strong) g5Reminder *reminder;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
