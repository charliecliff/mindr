//
//  g5ConditionTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionTableViewCell.h"
#import "g5Condition.h"
#import "g5ConfigAndMacros.h"

@interface g5ConditionTableViewCell ()

@property(nonatomic, strong) g5Condition *condition;

@property(nonatomic, strong) IBOutlet UIImageView *conditionIconImageView;
@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UILabel *conditionExplanationLabel;
@property(nonatomic, strong) IBOutlet UISwitch *conditionActivationSwitch;

@end

@implementation g5ConditionTableViewCell

#pragma mark - Configuration

- (void)configureForActiveCondition:(g5Condition *)condition {
    self.condition = condition;
    [self reload];
}

- (void)configureForInActiveCondition:(g5Condition *)condition {
    self.condition = condition;
    [self reload];
}

- (void)reload {
    [self.conditionExplanationLabel setText:self.condition.placeholderText];
    [self.backgroundImageView setHidden:!self.condition.isActive];
    [self.conditionActivationSwitch setOn:self.condition.isActive];
    
    if (self.condition.isActive) {
        [self.conditionExplanationLabel setTextColor:[UIColor whiteColor]];
        [self.conditionIconImageView setImage:[self activeImageForCondition:self.condition]];
    }
    else {
        [self.conditionExplanationLabel setTextColor:SECONDARY_FILL_COLOR];
        [self.conditionIconImageView setImage:[self inActiveImageForCondition:self.condition]];
    }
}

#pragma mark - Images

- (UIImage *)activeImageForCondition:(g5Condition *)condition {
    NSString *activeImageName = [NSString stringWithFormat:@"%@_on", condition.type];
    UIImage *activeImage = [UIImage imageNamed:activeImageName];
    return activeImage;
}

- (UIImage *)inActiveImageForCondition:(g5Condition *)condition {
    NSString *activeImageName = [NSString stringWithFormat:@"%@_off",condition.type];
    UIImage *activeImage = [UIImage imageNamed:activeImageName];
    return activeImage;
}

#pragma mark - Actions

- (IBAction)didToddleActivationSwitch:(id)sender {
    [self.delegate g5Condition:self.condition didSetActive:self.conditionActivationSwitch.isOn];

    [self.condition setIsActive:self.conditionActivationSwitch.isOn];
    [self reload];
}

@end
