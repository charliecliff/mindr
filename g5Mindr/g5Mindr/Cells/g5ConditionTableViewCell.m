//
//  g5ConditionTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionTableViewCell.h"
#import "MDRCondition.h"
#import "BuoyToggleView.h"
#import "g5ConfigAndMacros.h"

@interface g5ConditionTableViewCell ()

// PROTECTED
@property(nonatomic, strong, readwrite) MDRCondition *condition;

// OUTLETS
@property(nonatomic, strong) IBOutlet UIImageView *conditionIconImageView;
@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UILabel *conditionExplanationLabel;
@property(nonatomic, strong) IBOutlet UISwitch *conditionActivationSwitch;
@property(nonatomic, strong) IBOutlet BuoyToggleView *onSwitch;

@end

@implementation g5ConditionTableViewCell

#pragma mark - Setters

- (void)setConditionActive:(BOOL)isActive {
    [self toggleSwitch:isActive withCompletionBlock:^{
        [self reload];
    }];
}

#pragma mark - Configuration

- (void)configureForCondition:(MDRCondition *)condition {
    self.condition = condition;
    [self reload];
}

- (void)reload {
    [self.conditionExplanationLabel setText:self.condition.conditionDescription];
    
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

- (UIImage *)activeImageForCondition:(MDRCondition *)condition {
    NSString *activeImageName = [NSString stringWithFormat:@"%@_on", condition.type];
    UIImage *activeImage = [UIImage imageNamed:activeImageName];
    return activeImage;
}

- (UIImage *)inActiveImageForCondition:(MDRCondition *)condition {
    NSString *activeImageName = [NSString stringWithFormat:@"%@_off",condition.type];
    UIImage *activeImage = [UIImage imageNamed:activeImageName];
    return activeImage;
}

#pragma mark - Actions

- (IBAction)didPressSwitchButton:(id)sender {
    BOOL newConditionActiveState = (!self.condition.isActive);
    [self.delegate conditionCell:self didSetActive:newConditionActiveState];
}

#pragma mark - Animations

- (void)toggleSwitch:(BOOL)isActive withCompletionBlock:(void (^)(void))completionBlock {
    if (isActive)
        [self.onSwitch addToggleOnAnimation];
    else
        [self.onSwitch addToggleOffAnimation];
    if (completionBlock) completionBlock();
}

@end
