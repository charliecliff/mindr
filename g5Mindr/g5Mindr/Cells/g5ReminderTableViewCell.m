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
    
    if (reminder.isActive) {
        [self.onSwitch addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.000 andRemoveOnCompletion:NO completion:NULL];
        [self reload];
    }
    else {
        [self.onSwitch addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.000 andRemoveOnCompletion:NO completion:NULL];
    }
}

- (void)reload {
//    [self.conditionExplanationLabel setText:self.condition.placeholderText];
//    [self.backgroundImageView setHidden:!self.condition.isActive];
//    [self.conditionActivationSwitch setOn:self.condition.isActive];
//    
//    if (self.condition.isActive) {
//        [self.conditionExplanationLabel setTextColor:[UIColor whiteColor]];
//        [self.conditionIconImageView setImage:[self activeImageForCondition:self.condition]];
//    }
//    else {
//        [self.conditionExplanationLabel setTextColor:SECONDARY_FILL_COLOR];
//        [self.conditionIconImageView setImage:[self inActiveImageForCondition:self.condition]];
//    }
}

#pragma mark - Actions

- (IBAction)didPressSwitchButton:(id)sender {
    BOOL newReminderActiveState = (!self.reminder.isActive);
    [self.delegate g5Reminder:self.reminder didSetActive:newReminderActiveState];
    [self.reminder setIsActive:newReminderActiveState];

    if (self.reminder.isActive) {
        [self.onSwitch addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:NULL];
    }
    else {
        [self.onSwitch addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:NULL];
    }
    
    [self reload];
}

@end
