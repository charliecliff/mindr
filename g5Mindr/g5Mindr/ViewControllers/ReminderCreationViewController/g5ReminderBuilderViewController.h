//
//  g5ReminderBuilderViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class g5Reminder;

@protocol g5ReminderBuilderDelegate <NSObject>

//- (CLLocation *)currentLocation;

@end

@interface g5ReminderBuilderViewController : UIViewController

@property(nonatomic, strong) g5Reminder *reminder;
@property(nonatomic, strong) id<g5ReminderBuilderDelegate> delegate;


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder withDelegate:(id<g5ReminderBuilderDelegate>)delegate;

@end
