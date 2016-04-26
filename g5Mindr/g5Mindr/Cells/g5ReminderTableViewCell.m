//
//  g5ReminderTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderTableViewCell.h"
#import "OnSwitchView.h"

@interface g5ReminderTableViewCell ()

@property(nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *explanationLabel;
@property(nonatomic, strong) IBOutlet OnSwitchView *onSwitch;
@property(nonatomic, strong) IBOutlet UIButton *onSwitchButton;

@property(nonatomic, strong, readwrite) g5Reminder *reminder;

@end

@implementation g5ReminderTableViewCell

#pragma mark - Configure

- (void)configureWithReminder:(g5Reminder *)reminder {
    self.reminder = reminder;
    [self.titleLabel setText:self.reminder.name];
    [self.explanationLabel setText:self.reminder.shortExplanation];
}

#pragma mark - Actions

- (IBAction)didPressSwitchButton:(id)sender {
//    BOOL newConditionActiveState = (!self.condition.isActive);
//    [self.delegate g5Condition:self.condition didSetActive:newConditionActiveState];
//    [self.condition setIsActive:newConditionActiveState];
//    
//    if (self.condition.isActive) {
//        [self.onSwitch addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:NULL];
//    }
//    else {
//        [self.onSwitch addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:NULL];
//    }
//    
//    [self reload];
}

@end
