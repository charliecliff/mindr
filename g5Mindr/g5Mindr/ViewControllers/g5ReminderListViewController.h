//
//  g5ReminderListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HROBounceNavigationController.h"

@interface g5ReminderListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@property(nonatomic, weak) HROBounceNavigationController *bounceNavigationController;

@end
