//
// OnSwitchView.m
// Generated by Core Animator version 1.3.1 on 4/25/16.
//
// DO NOT MODIFY THIS FILE. IT IS AUTO-GENERATED AND WILL BE OVERWRITTEN
//

#import "OnSwitchView.h"

@interface OnSwitchView ()
@property (strong, nonatomic) NSMapTable *completionBlocksByAnimation;
@end

@implementation OnSwitchView

#pragma mark - Life Cycle

- (instancetype)init
{
	return [self initWithFrame:CGRectMake(0,0,106,66)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		[self setupHierarchy];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self)
	{
		[self setupHierarchy];
	}
	return self;
}

#pragma mark - Scaling

- (void)layoutSubviews
{
	[super layoutSubviews];

	UIView *scalingView = self.viewsByName[@"__scaling__"];
	float xScale = self.bounds.size.width / scalingView.bounds.size.width;
	float yScale = self.bounds.size.height / scalingView.bounds.size.height;
	switch (self.contentMode) {
		case UIViewContentModeScaleToFill:
			break;
		case UIViewContentModeScaleAspectFill:
		{
			float scale = MAX(xScale, yScale);
			xScale = scale;
			yScale = scale;
			break;
		}
		default:
		{
			float scale = MIN(xScale, yScale);
			xScale = scale;
			yScale = scale;
			break;
		}
	}
	scalingView.transform = CGAffineTransformMakeScale(xScale, yScale);
	scalingView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - Setup

- (void)setupHierarchy
{
	self.completionBlocksByAnimation = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory valueOptions:NSPointerFunctionsStrongMemory];
	NSMutableDictionary *viewsByName = [NSMutableDictionary dictionary];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];

	UIView *__scaling__ = [UIView new];
	__scaling__.bounds = CGRectMake(0, 0, 106, 66);
	__scaling__.center = CGPointMake(53.0, 33.0);
	__scaling__.layer.masksToBounds = YES;
	[self addSubview:__scaling__];
	viewsByName[@"__scaling__"] = __scaling__;

	UIImageView *newSwitch = [UIImageView new];
	newSwitch.bounds = CGRectMake(0, 0, 53.0, 33.0);
	UIImage *imgSwitch = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"Switch.png" ofType:nil]];
	if ( imgSwitch == nil ) { NSLog(@"** Warning: Could not create image from 'Switch.png'. Please make sure that it is added to the project directly (not in a folder reference)."); }
	newSwitch.image = imgSwitch;
	newSwitch.contentMode = UIViewContentModeCenter;
	newSwitch.layer.position = CGPointMake(53.000, 33.000);
	newSwitch.transform = CGAffineTransformMakeScale(2.00, 2.00);
	[__scaling__ addSubview:newSwitch];
	viewsByName[@"Switch"] = newSwitch;

	UIImageView *offSwitchBackground = [UIImageView new];
	offSwitchBackground.bounds = CGRectMake(0, 0, 53.0, 33.0);
	UIImage *imgOffSwitchBackground = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"offSwitchBackground.png" ofType:nil]];
	if ( imgOffSwitchBackground == nil ) { NSLog(@"** Warning: Could not create image from 'offSwitchBackground.png'. Please make sure that it is added to the project directly (not in a folder reference)."); }
	offSwitchBackground.image = imgOffSwitchBackground;
	offSwitchBackground.contentMode = UIViewContentModeCenter;
	offSwitchBackground.layer.position = CGPointMake(53.000, 33.000);
	offSwitchBackground.alpha = 0.00;
	offSwitchBackground.transform = CGAffineTransformMakeScale(2.00, 2.00);
	[__scaling__ addSubview:offSwitchBackground];
	viewsByName[@"offSwitchBackground"] = offSwitchBackground;

	UIImageView *onSwitchKnob = [UIImageView new];
	onSwitchKnob.bounds = CGRectMake(0, 0, 33.0, 33.0);
	UIImage *imgOnSwitchKnob = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"onSwitchKnob.png" ofType:nil]];
	if ( imgOnSwitchKnob == nil ) { NSLog(@"** Warning: Could not create image from 'onSwitchKnob.png'. Please make sure that it is added to the project directly (not in a folder reference)."); }
	onSwitchKnob.image = imgOnSwitchKnob;
	onSwitchKnob.contentMode = UIViewContentModeCenter;
	onSwitchKnob.layer.position = CGPointMake(73.000, 33.000);
	onSwitchKnob.transform = CGAffineTransformMakeScale(2.00, 2.00);
	[__scaling__ addSubview:onSwitchKnob];
	viewsByName[@"onSwitchKnob"] = onSwitchKnob;

	UIImageView *offSwitchKnob = [UIImageView new];
	offSwitchKnob.bounds = CGRectMake(0, 0, 33.0, 33.0);
	UIImage *imgOffSwitchKnob = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"offSwitchKnob.png" ofType:nil]];
	if ( imgOffSwitchKnob == nil ) { NSLog(@"** Warning: Could not create image from 'offSwitchKnob.png'. Please make sure that it is added to the project directly (not in a folder reference)."); }
	offSwitchKnob.image = imgOffSwitchKnob;
	offSwitchKnob.contentMode = UIViewContentModeCenter;
	offSwitchKnob.layer.position = CGPointMake(73.000, 33.000);
	offSwitchKnob.alpha = 0.00;
	offSwitchKnob.transform = CGAffineTransformMakeScale(2.00, 2.00);
	[__scaling__ addSubview:offSwitchKnob];
	viewsByName[@"offSwitchKnob"] = offSwitchKnob;

	self.viewsByName = viewsByName;
}

#pragma mark - OFF

- (void)addOFFAnimation
{
    [self addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:NULL];
}

- (void)addOFFAnimationWithCompletion:(void (^)(BOOL finished))completionBlock
{
	[self addOFFAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:completionBlock];
}

- (void)addOFFAnimationAndRemoveOnCompletion:(BOOL)removedOnCompletion
{
	[self addOFFAnimationWithBeginTime:0 andFillMode:removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:removedOnCompletion completion:NULL];
}

- (void)addOFFAnimationAndRemoveOnCompletion:(BOOL)removedOnCompletion completion:(void (^)(BOOL finished))completionBlock
{
	[self addOFFAnimationWithBeginTime:0 andFillMode:removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:removedOnCompletion completion:completionBlock];
}

- (void)addOFFAnimationWithBeginTime:(CFTimeInterval)beginTime andFillMode:(NSString *)fillMode withDuration:(CFTimeInterval)duration andRemoveOnCompletion:(BOOL)removedOnCompletion completion:(void (^)(BOOL finished))completionBlock
{    
    CAMediaTimingFunction *linearTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    if (completionBlock)
    {
        CABasicAnimation *representativeAnimation = [CABasicAnimation animationWithKeyPath:@"not.a.real.key"];
        representativeAnimation.duration = duration;
        representativeAnimation.delegate = self;
        [self.layer addAnimation:representativeAnimation forKey:@"OFF"];
        [self.completionBlocksByAnimation setObject:completionBlock forKey:[self.layer animationForKey:@"OFF"]];
    }
    
    CAKeyframeAnimation *switchOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    switchOpacityAnimation.duration = duration;
    switchOpacityAnimation.values = @[@(1.000), @(0.000)];
    switchOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    switchOpacityAnimation.timingFunctions = @[linearTiming];
    switchOpacityAnimation.beginTime = beginTime;
    switchOpacityAnimation.fillMode = fillMode;
    switchOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"Switch"] layer] addAnimation:switchOpacityAnimation forKey:@"OFF_Opacity"];
    
    CAKeyframeAnimation *offSwitchBackgroundOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    offSwitchBackgroundOpacityAnimation.duration = duration;
    offSwitchBackgroundOpacityAnimation.values = @[@(0.000), @(1.000)];
    offSwitchBackgroundOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    offSwitchBackgroundOpacityAnimation.timingFunctions = @[linearTiming];
    offSwitchBackgroundOpacityAnimation.beginTime = beginTime;
    offSwitchBackgroundOpacityAnimation.fillMode = fillMode;
    offSwitchBackgroundOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"offSwitchBackground"] layer] addAnimation:offSwitchBackgroundOpacityAnimation forKey:@"OFF_Opacity"];
    
    CAKeyframeAnimation *offSwitchKnobOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    offSwitchKnobOpacityAnimation.duration = duration;
    offSwitchKnobOpacityAnimation.values = @[@(0.000), @(1.000)];
    offSwitchKnobOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    offSwitchKnobOpacityAnimation.timingFunctions = @[linearTiming];
    offSwitchKnobOpacityAnimation.beginTime = beginTime;
    offSwitchKnobOpacityAnimation.fillMode = fillMode;
    offSwitchKnobOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"offSwitchKnob"] layer] addAnimation:offSwitchKnobOpacityAnimation forKey:@"OFF_Opacity"];
    
    CAKeyframeAnimation *offSwitchKnobTranslationXAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    offSwitchKnobTranslationXAnimation.duration = duration;
    offSwitchKnobTranslationXAnimation.values = @[@(0.000), @(-40.000)];
    offSwitchKnobTranslationXAnimation.keyTimes = @[@(0.000), @(1.000)];
    offSwitchKnobTranslationXAnimation.timingFunctions = @[linearTiming];
    offSwitchKnobTranslationXAnimation.beginTime = beginTime;
    offSwitchKnobTranslationXAnimation.fillMode = fillMode;
    offSwitchKnobTranslationXAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"offSwitchKnob"] layer] addAnimation:offSwitchKnobTranslationXAnimation forKey:@"OFF_TranslationX"];
    
    CAKeyframeAnimation *onSwitchKnobOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    onSwitchKnobOpacityAnimation.duration = duration;
    onSwitchKnobOpacityAnimation.values = @[@(1.000), @(0.000)];
    onSwitchKnobOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    onSwitchKnobOpacityAnimation.timingFunctions = @[linearTiming];
    onSwitchKnobOpacityAnimation.beginTime = beginTime;
    onSwitchKnobOpacityAnimation.fillMode = fillMode;
    onSwitchKnobOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"onSwitchKnob"] layer] addAnimation:onSwitchKnobOpacityAnimation forKey:@"OFF_Opacity"];
    
    CAKeyframeAnimation *onSwitchKnobTranslationXAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    onSwitchKnobTranslationXAnimation.duration = duration;
    onSwitchKnobTranslationXAnimation.values = @[@(0.000), @(-40.000)];
    onSwitchKnobTranslationXAnimation.keyTimes = @[@(0.000), @(1.000)];
    onSwitchKnobTranslationXAnimation.timingFunctions = @[linearTiming];
    onSwitchKnobTranslationXAnimation.beginTime = beginTime;
    onSwitchKnobTranslationXAnimation.fillMode = fillMode;
    onSwitchKnobTranslationXAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"onSwitchKnob"] layer] addAnimation:onSwitchKnobTranslationXAnimation forKey:@"OFF_TranslationX"];
}

- (void)removeOFFAnimation
{
	[self.layer removeAnimationForKey:@"OFF"];
	[[self.viewsByName[@"Switch"] layer] removeAnimationForKey:@"OFF_Opacity"];
	[[self.viewsByName[@"offSwitchBackground"] layer] removeAnimationForKey:@"OFF_Opacity"];
	[[self.viewsByName[@"offSwitchKnob"] layer] removeAnimationForKey:@"OFF_Opacity"];
	[[self.viewsByName[@"offSwitchKnob"] layer] removeAnimationForKey:@"OFF_TranslationX"];
	[[self.viewsByName[@"onSwitchKnob"] layer] removeAnimationForKey:@"OFF_Opacity"];
	[[self.viewsByName[@"onSwitchKnob"] layer] removeAnimationForKey:@"OFF_TranslationX"];
}

#pragma mark - OFF_reversed

- (void)addOFFReversedAnimation
{
	[self addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:NULL];
}

- (void)addOFFReversedAnimationWithCompletion:(void (^)(BOOL finished))completionBlock
{
	[self addOFFReversedAnimationWithBeginTime:0 andFillMode:kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:NO completion:completionBlock];
}

- (void)addOFFReversedAnimationAndRemoveOnCompletion:(BOOL)removedOnCompletion
{
	[self addOFFReversedAnimationWithBeginTime:0 andFillMode:removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:removedOnCompletion completion:NULL];
}

- (void)addOFFReversedAnimationAndRemoveOnCompletion:(BOOL)removedOnCompletion completion:(void (^)(BOOL finished))completionBlock
{
	[self addOFFReversedAnimationWithBeginTime:0 andFillMode:removedOnCompletion ? kCAFillModeRemoved : kCAFillModeBoth withDuration:0.200 andRemoveOnCompletion:removedOnCompletion completion:completionBlock];
}

- (void)addOFFReversedAnimationWithBeginTime:(CFTimeInterval)beginTime andFillMode:(NSString *)fillMode withDuration:(CFTimeInterval)duration andRemoveOnCompletion:(BOOL)removedOnCompletion completion:(void (^)(BOOL finished))completionBlock
{
    CAMediaTimingFunction *linearTiming = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    if (completionBlock)
    {
        CABasicAnimation *representativeAnimation = [CABasicAnimation animationWithKeyPath:@"not.a.real.key"];
        representativeAnimation.duration = duration;
        representativeAnimation.delegate = self;
        [self.layer addAnimation:representativeAnimation forKey:@"OFFReversed"];
        [self.completionBlocksByAnimation setObject:completionBlock forKey:[self.layer animationForKey:@"OFFReversed"]];
    }
    
    CAKeyframeAnimation *switchOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    switchOpacityAnimation.duration = duration;
    switchOpacityAnimation.values = @[@(0.000), @(1.000)];
    switchOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    switchOpacityAnimation.timingFunctions = @[linearTiming];
    switchOpacityAnimation.beginTime = beginTime;
    switchOpacityAnimation.fillMode = fillMode;
    switchOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"Switch"] layer] addAnimation:switchOpacityAnimation forKey:@"OFF_reversed_Opacity"];
    
    CAKeyframeAnimation *offSwitchBackgroundOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    offSwitchBackgroundOpacityAnimation.duration = duration;
    offSwitchBackgroundOpacityAnimation.values = @[@(1.000), @(0.000)];
    offSwitchBackgroundOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    offSwitchBackgroundOpacityAnimation.timingFunctions = @[linearTiming];
    offSwitchBackgroundOpacityAnimation.beginTime = beginTime;
    offSwitchBackgroundOpacityAnimation.fillMode = fillMode;
    offSwitchBackgroundOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"offSwitchBackground"] layer] addAnimation:offSwitchBackgroundOpacityAnimation forKey:@"OFF_reversed_Opacity"];
    
    CAKeyframeAnimation *offSwitchKnobOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    offSwitchKnobOpacityAnimation.duration = duration;
    offSwitchKnobOpacityAnimation.values = @[@(1.000), @(0.000)];
    offSwitchKnobOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    offSwitchKnobOpacityAnimation.timingFunctions = @[linearTiming];
    offSwitchKnobOpacityAnimation.beginTime = beginTime;
    offSwitchKnobOpacityAnimation.fillMode = fillMode;
    offSwitchKnobOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"offSwitchKnob"] layer] addAnimation:offSwitchKnobOpacityAnimation forKey:@"OFF_reversed_Opacity"];
    
    CAKeyframeAnimation *offSwitchKnobTranslationXAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    offSwitchKnobTranslationXAnimation.duration = duration;
    offSwitchKnobTranslationXAnimation.values = @[@(-40.000), @(0.000)];
    offSwitchKnobTranslationXAnimation.keyTimes = @[@(0.000), @(1.000)];
    offSwitchKnobTranslationXAnimation.timingFunctions = @[linearTiming];
    offSwitchKnobTranslationXAnimation.beginTime = beginTime;
    offSwitchKnobTranslationXAnimation.fillMode = fillMode;
    offSwitchKnobTranslationXAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"offSwitchKnob"] layer] addAnimation:offSwitchKnobTranslationXAnimation forKey:@"OFF_reversed_TranslationX"];
    
    CAKeyframeAnimation *onSwitchKnobOpacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    onSwitchKnobOpacityAnimation.duration = duration;
    onSwitchKnobOpacityAnimation.values = @[@(0.000), @(1.000)];
    onSwitchKnobOpacityAnimation.keyTimes = @[@(0.000), @(1.000)];
    onSwitchKnobOpacityAnimation.timingFunctions = @[linearTiming];
    onSwitchKnobOpacityAnimation.beginTime = beginTime;
    onSwitchKnobOpacityAnimation.fillMode = fillMode;
    onSwitchKnobOpacityAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"onSwitchKnob"] layer] addAnimation:onSwitchKnobOpacityAnimation forKey:@"OFF_reversed_Opacity"];
    
    CAKeyframeAnimation *onSwitchKnobTranslationXAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    onSwitchKnobTranslationXAnimation.duration = duration;
    onSwitchKnobTranslationXAnimation.values = @[@(-40.000), @(0.000)];
    onSwitchKnobTranslationXAnimation.keyTimes = @[@(0.000), @(1.000)];
    onSwitchKnobTranslationXAnimation.timingFunctions = @[linearTiming];
    onSwitchKnobTranslationXAnimation.beginTime = beginTime;
    onSwitchKnobTranslationXAnimation.fillMode = fillMode;
    onSwitchKnobTranslationXAnimation.removedOnCompletion = removedOnCompletion;
    [[self.viewsByName[@"onSwitchKnob"] layer] addAnimation:onSwitchKnobTranslationXAnimation forKey:@"OFF_reversed_TranslationX"];
}

- (void)removeOFFReversedAnimation
{
	[self.layer removeAnimationForKey:@"OFFReversed"];
	[[self.viewsByName[@"Switch"] layer] removeAnimationForKey:@"OFF_reversed_Opacity"];
	[[self.viewsByName[@"offSwitchBackground"] layer] removeAnimationForKey:@"OFF_reversed_Opacity"];
	[[self.viewsByName[@"offSwitchKnob"] layer] removeAnimationForKey:@"OFF_reversed_Opacity"];
	[[self.viewsByName[@"offSwitchKnob"] layer] removeAnimationForKey:@"OFF_reversed_TranslationX"];
	[[self.viewsByName[@"onSwitchKnob"] layer] removeAnimationForKey:@"OFF_reversed_Opacity"];
	[[self.viewsByName[@"onSwitchKnob"] layer] removeAnimationForKey:@"OFF_reversed_TranslationX"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	void (^completion)(BOOL) = [self.completionBlocksByAnimation objectForKey:anim];
	[self.completionBlocksByAnimation removeObjectForKey:anim];
	if (completion)
	{
		completion(flag);
	}
}

- (void)removeAllAnimations
{
	for (UIView *view in self.viewsByName.allValues)
	{
		[view.layer removeAllAnimations];
	}
	[self.layer removeAnimationForKey:@"OFF"];
	[self.layer removeAnimationForKey:@"OFFReversed"];
}

@end