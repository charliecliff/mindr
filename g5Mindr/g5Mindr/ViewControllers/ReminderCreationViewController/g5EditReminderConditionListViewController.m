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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bounceNavigationController hideCenterButtonWithCompletion:nil];
    [self.bounceNavigationController hideCornerButtonsWithCompletion:nil];
    [self.bounceNavigationController hidePreviousButtonWithCompletion:nil];
    self.bounceNavigationController.delegate = self;
}

@end
