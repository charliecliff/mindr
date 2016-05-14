//
//  g5ConditionListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5BounceNavigationController.h"
#import "g5Reminder.h"

@protocol g5ConditionListViewControllerDelegate <NSObject>

@required
- (void)didSelectConditionCell;

@end

@interface g5ConditionListViewController : UITableViewController <g5BounceNavigationDelegate>

@property(nonatomic, strong) g5Reminder *reminder;
@property(nonatomic, strong) id<g5ConditionListViewControllerDelegate> delegate;

@property(nonatomic, weak) g5BounceNavigationController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
