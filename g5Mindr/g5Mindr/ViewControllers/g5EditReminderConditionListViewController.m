//
//  g5EditReminderConditionListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/13/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5EditReminderConditionListViewController.h"

@interface g5EditReminderConditionListViewController ()

@end

@implementation g5EditReminderConditionListViewController

#pragma mark - Init

- (instancetype)initWithReminder:(g5Reminder *)reminder {
    self = [super initWithReminder:reminder];
    if (self) {
        self.navigationItem.title = @"Edit Conditions";
        
        [self setUpSkipButton];
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    self.bounceNavigationController.delegate = self;
}

- (void)setUpSkipButton {
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"button_back_grey"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButtonView addSubview:backButton];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    
    self.navigationItem.leftBarButtonItem = barBtn;
}

#pragma mark - Actions

- (void)pressBackButton {
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

@end
