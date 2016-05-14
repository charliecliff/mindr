//
//  g5CreateReminderConditionListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/13/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5CreateReminderConditionListViewController.h"

@interface g5CreateReminderConditionListViewController ()

@end

@implementation g5CreateReminderConditionListViewController

#pragma mark - View Life-Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
}

- (void)reload {
    if ([super.reminder hasActiveConditions]) {
        [self.bounceNavigationController setRightButtonEnabled:YES];
    }
    else {
        [self.bounceNavigationController setRightButtonEnabled:NO];
    }
    [self.tableView reloadData];
}

@end
