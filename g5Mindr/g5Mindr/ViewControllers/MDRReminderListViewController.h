//
//  g5ReminderListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mindrBounceNavigationViewController.h"

@interface MDRReminderListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

@end
