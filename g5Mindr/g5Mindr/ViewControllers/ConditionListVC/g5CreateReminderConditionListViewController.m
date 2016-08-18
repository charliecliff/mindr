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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpProgressLabel];
}

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

#pragma mark - Set Up

- (void)setUpProgressLabel {
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    progressLabel.text = @"1/3";
    progressLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:183.0/255.0 blue:230.0/255.0 alpha:1];
    progressLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    [barView addSubview:progressLabel];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barView];
    self.navigationItem.leftBarButtonItem = barBtn;
}

@end
