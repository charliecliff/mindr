//
//  g5ReminderDetailViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderDetailViewController.h"

@interface g5ReminderDetailViewController ()

@end

@implementation g5ReminderDetailViewController

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
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressCompleteButton:(id)sender {

}

@end
