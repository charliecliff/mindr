//
//  g5ReminderTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderTableViewCell.h"
#import "OnSwitchView.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderTableViewCell ()

@property(nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *innerRingImageView;

@property(nonatomic, strong) IBOutlet UILabel *emoticonLabel;
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
    [self.explanationLabel setText:self.reminder.shortExplanation];
    [self.emoticonLabel setText:self.reminder.emoticonUnicodeCharacter];
    
    [self configureOuterRingWithColor:[UIColor whiteColor]];
    [self configureInnerRingWithColor:PRIMARY_STROKE_COLOR];
    
    if (reminder.isActive) {
        [self.onSwitch addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.000 andRemoveOnCompletion:NO completion:NULL];
    }
    else {
        [self.onSwitch addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.000 andRemoveOnCompletion:NO completion:NULL];
    }
}

- (void)configureOuterRingWithColor:(UIColor *)color {
    CGFloat radius = self.outerRingImageView.frame.size.width/2;
    CGPoint center = CGPointMake(self.outerRingImageView.frame.size.width, self.outerRingImageView.frame.size.height);
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.outerRingImageView bounds].size.width, [self.outerRingImageView bounds].size.height)];
    [circleLayer setPosition:CGPointMake(0,0)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:[color CGColor]];
    [circleLayer setLineWidth:0.0f];
    
    [[self.outerRingImageView layer] addSublayer:circleLayer];
}

- (void)configureInnerRingWithColor:(UIColor *)color {
    CGFloat radius = self.innerRingImageView.frame.size.width/2;
    CGPoint center = CGPointMake(self.innerRingImageView.frame.size.width, self.innerRingImageView.frame.size.height);
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.innerRingImageView bounds].size.width, [self.innerRingImageView bounds].size.height)];
    [circleLayer setPosition:CGPointMake(0,0)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:[color CGColor]];
    [circleLayer setLineWidth:0.0f];
    
    [[self.innerRingImageView layer] addSublayer:circleLayer];
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
