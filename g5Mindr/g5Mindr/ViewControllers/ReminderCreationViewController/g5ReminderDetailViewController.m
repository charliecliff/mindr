//
//  g5ReminderDetailViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderDetailViewController.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderDetailViewController ()

@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *backButtonBackground;

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
    [self setUpNextButtonBackground];
    [self setUpBackButtonBackground];
}

#pragma mark - Set Up

- (void)setUpNextButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.nextButtonBackground bounds].size.width, [self.nextButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.nextButtonBackground bounds]),CGRectGetMidY([self.nextButtonBackground bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.nextButtonBackground.frame.size.width, self.nextButtonBackground.frame.size.height) radius:self.nextButtonBackground.frame.size.width startAngle:3*M_PI_4 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[PRIMARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.nextButtonBackground layer] addSublayer:circleLayer];
}

- (void)setUpBackButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.backButtonBackground bounds].size.width, [self.backButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.backButtonBackground bounds]),CGRectGetMidY([self.backButtonBackground bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, self.backButtonBackground.frame.size.height) radius:self.backButtonBackground.frame.size.width startAngle:M_PI_2 endAngle:3*M_PI_2 clockwise:NO];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.backButtonBackground layer] addSublayer:circleLayer];
}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressCompleteButton:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];

}

@end
