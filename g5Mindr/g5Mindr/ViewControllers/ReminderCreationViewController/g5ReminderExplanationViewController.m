//
//  g5ReminderExplanationViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderExplanationViewController.h"
#import "g5BounceNavigationController.h"
#import "g5ReminderManager.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderExplanationViewController () <g5BounceNavigationDelegate>

@end

@implementation g5ReminderExplanationViewController

#pragma mark - Init

- (instancetype)initWithReminder:(g5Reminder *)reminder {
    self = [super init];
    if (self != nil) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - view Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    assert(false);
}

- (void)didPressNextButton {
    [self.bounceNavigationController hideCornerButtonsWithCompletion:^{
        [self.bounceNavigationController displayCenterButtonOntoScreenWithCompletion:nil];
    }];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didPressCancelButton {
    [self.bounceNavigationController hideCornerButtonsWithCompletion:^{
        [self.bounceNavigationController displayCenterButtonOntoScreenWithCompletion:nil];
    }];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
