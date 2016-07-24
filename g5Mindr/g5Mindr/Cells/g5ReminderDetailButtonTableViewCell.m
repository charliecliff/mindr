//
//  g5ReminderDetailButtonTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/8/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderDetailButtonTableViewCell.h"
#import "MDRReminder.h"

@interface g5ReminderDetailButtonTableViewCell ()

@property(nonatomic) BOOL switchShouldBeOn;

@end

@implementation g5ReminderDetailButtonTableViewCell

#pragma mark - Config

- (void)configWithReminder:(MDRReminder *)reminder withDelegate:(id<g5ReminderButtonCellDelegate>)delegate {
    self.delegate = delegate;
//    self.switchShouldBeOn = reminder.isIconOnlyNotification;
    if (!self.switchShouldBeOn) {
        [self.onSwitch addToggleOnAnimation];
//        [self.onSwitch addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.00 andRemoveOnCompletion:NO completion:NULL];
    }
}

#pragma mark - Actions

- (IBAction)didPressSwitchButton:(id)sender {
    self.switchShouldBeOn = !self.switchShouldBeOn;
    if (self.switchShouldBeOn) {
        [self.onSwitch addToggleOnAnimation];
//        [self.onSwitch addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.2 andRemoveOnCompletion:NO completion:NULL];
    }
    else {
        [self.onSwitch addToggleOffAnimation];
//        [self.onSwitch addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.2 andRemoveOnCompletion:NO completion:NULL];
    }
    
    [self.delegate didPressSwitchButton];
}

@end
