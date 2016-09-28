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

@interface MDRReminderDetailTableViewController : UITableViewController

@property(nonatomic, strong) MDRReminder *reminder;

@end

@interface MDRReminderViewController : UIViewController <HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;
@property(nonatomic, strong) MDRReminder *reminder;

@end
