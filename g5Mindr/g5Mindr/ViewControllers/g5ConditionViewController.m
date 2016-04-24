//
//  g5ConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionViewController.h"
#import "g5ConfigAndMacros.h"

@interface g5ConditionViewController ()

@end

@implementation g5ConditionViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBackButton];
}

#pragma mark - Set Up

- (void)setUpBackButton {
    CGFloat radius = self.backButtonBackgroundImageView.frame.size.width/2;
    CGPoint center = CGPointMake(self.backButtonBackgroundImageView.frame.size.width, self.backButtonBackgroundImageView.frame.size.height);
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.backButtonBackgroundImageView bounds].size.width, [self.backButtonBackgroundImageView bounds].size.height)];
    [circleLayer setPosition:CGPointMake(0,0)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.backButtonBackgroundImageView layer] addSublayer:circleLayer];
}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end