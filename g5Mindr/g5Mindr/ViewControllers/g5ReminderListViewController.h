//
//  g5ReminderListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5BounceNavigationController.h"

@interface g5ReminderListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, g5BounceNavigationDatasource, g5BounceNavigationDelegate>

@property(nonatomic, weak) g5BounceNavigationController *bounceNavigationController;

@end
