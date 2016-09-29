//
//  g5ReminderTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderTableViewCell.h"
#import "BuoyToggleView.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderTableViewCell ()

// PTIVATE
@property(nonatomic, strong, readwrite) MDRReminder *reminder;

// OUTLET
@property(nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *innerRingImageView;
@property(nonatomic, strong) IBOutlet UILabel *emoticonLabel;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *explanationLabel;
@property(nonatomic, strong) IBOutlet BuoyToggleView *onSwitch;
@property(nonatomic, strong) IBOutlet UIButton *onSwitchButton;

@end

@implementation g5ReminderTableViewCell

#pragma mark - Configure


- (void)configureWithReminder:(MDRReminder *)reminder {
  
  self.reminder = reminder;
  [self layoutIfNeeded];
  [self.titleLabel setText:self.reminder.title];
  [self.explanationLabel setText:self.reminder.explanation];
  [self.emoticonLabel setText:self.reminder.emoji];
  [self configureOuterRingWithColor:[UIColor whiteColor]];
  [self configureInnerRingWithColor:PRIMARY_STROKE_COLOR];
    
  if (reminder.isActive) {
    [self.onSwitch addToggleOnAnimation];
  } else {
    [self.onSwitch addToggleOffAnimation];
  }
  
  self.rightUtilityButtons = [self rightButtons];
}

- (void)configureOuterRingWithColor:(UIColor *)color {
  CGFloat radius = self.outerRingImageView.frame.size.width/2;
  self.outerRingImageView.layer.cornerRadius = radius;
}

- (void)configureInnerRingWithColor:(UIColor *)color {
  CGFloat radius = self.innerRingImageView.frame.size.width/2;
  self.innerRingImageView.layer.cornerRadius = radius;
}

#pragma mark - Actions

- (IBAction)didPressSwitchButton:(id)sender {
    BOOL newReminderActiveState = (!self.reminder.isActive);
    [self.reminderDelegate g5Reminder:self.reminder didSetActive:newReminderActiveState];
    [self.reminder setIsActive:newReminderActiveState];

    if (self.reminder.isActive)
        [self.onSwitch addToggleOnAnimation];
    else
        [self.onSwitch addToggleOffAnimation];
}

#pragma mark - Buttons

- (NSArray *)rightButtons {
  
  NSMutableArray *rightUtilityButtons = [NSMutableArray new];
  
  [rightUtilityButtons sw_addUtilityButtonWithColor:RED_COLOR
                                               icon:[UIImage imageNamed:@"button_delete"]];
  return rightUtilityButtons;
}
@end
