//
//  RootCell.m
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "g5EmoticonCell.h"

@interface g5EmoticonCell ()

@end

@implementation g5EmoticonCell

#pragma mark - Configuration

- (void)configureWithEmoticonName:(NSString *)emoticonName withOuterRingWithColor:(UIColor *)outerRingColor withInnerRingWithColor:(UIColor *)innerRingColor {
	
	UIImage *omage = [UIImage imageNamed:emoticonName];
    self.emojiImageView.image = [UIImage imageNamed:emoticonName];
  
    [self configureOuterRingWithColor:outerRingColor];
    [self configureInnerRingWithColor:innerRingColor];
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

#pragma mark - Setters

- (void)setHasSelectedEmoticon:(BOOL)hasSelectedEmoticon {
    _hasSelectedEmoticon = hasSelectedEmoticon;
    if (self.hasSelectedEmoticon) {
        [self.outerRingImageView setAlpha:1.0];
    }
    else {
        [self.outerRingImageView setAlpha:0.3];
    }
}

#pragma mark - Hacks to Fix Apple SDK Bullshit

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    self.contentView.frame = bounds;
}

@end
