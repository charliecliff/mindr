//
//  g5ConditionListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mindrBounceNavigationViewController.h"
#import "g5Reminder.h"

@protocol g5ConditionListViewControllerDelegate <NSObject>

@required
- (void)didSelectConditionCell;

@end

@interface g5ConditionListViewController : UITableViewController <HROBounceNavigationDelegate>

@property(nonatomic, strong) g5Reminder *reminder;
@property(nonatomic, strong) id<g5ConditionListViewControllerDelegate> delegate;

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
