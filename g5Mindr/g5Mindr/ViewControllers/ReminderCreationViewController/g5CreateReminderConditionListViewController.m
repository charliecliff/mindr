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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bounceNavigationController hideCenterButtonWithCompletion:^{
        [self.bounceNavigationController displayCornerButtonsOntoScreenWithCompletion:nil];
    }];
    [self.bounceNavigationController hidePreviousButtonWithCompletion:nil];
    [self reload];
}

- (void)reload {
    if ([super.reminder hasActiveConditions]) {
        [self.bounceNavigationController setNextButtonEnabled:YES];
    }
    else {
        [self.bounceNavigationController setNextButtonEnabled:NO];
    }
    [self.tableView reloadData];
}

@end
