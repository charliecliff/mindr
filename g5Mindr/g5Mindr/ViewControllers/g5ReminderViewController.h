//
//  g5ReminderViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class g5Reminder;

@interface g5ReminderViewController : UIViewController

@property(nonatomic, strong) g5Reminder *reminder;

- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
