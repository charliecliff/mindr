//
//  HROPageControl.m
//  g5Mindr
//
//  Created by Charles Cliff on 7/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "HROPageControl.h"

static NSInteger const HROUnderscoreHeight = 4;
static NSInteger const HROUnderscoreAnimationDuration = 0.2;

@protocol HROPageIconDelegate <NSObject>
@required
- (void)didSelectOptionForIndex:(NSInteger)index;
@end

@interface HROPageIcon : UIView

// PROTECTED
@property (nonatomic) NSInteger index;
@property (nonatomic, strong) UIColor *underscoreColor;
@property (nonatomic, strong) UIView *underscoreView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) id<HROPageIconDelegate> delegate;

- (instancetype)initWithDelegate:(id<HROPageIconDelegate>)delegate withImage:(UIImage *)image withHeight:(CGFloat)height atIndex:(NSInteger)index;

@end

@implementation HROPageIcon

- (instancetype)initWithDelegate:(id<HROPageIconDelegate>)delegate withImage:(UIImage *)image withHeight:(CGFloat)height atIndex:(NSInteger)index {
    self = [super initWithFrame:CGRectMake(height*index, 0, height, height)];
    if (self) {
        self.index = index;
        self.delegate = delegate;
        
        self.backgroundColor = [UIColor clearColor];

        CGFloat x = (self.frame.size.width  - image.size.width) /2;
        CGFloat y = (self.frame.size.height - image.size.height)/2;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(x, y, image.size.width, image.size.height);
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        self.underscoreView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - HROUnderscoreHeight,
                                                                       self.frame.size.width, HROUnderscoreHeight)];
        [self addSubview:self.underscoreView];
        self.underscoreView.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap)];
        [self addGestureRecognizer:gr];
    }
    return self;
}

- (void)didTap {
    [self.delegate didSelectOptionForIndex:self.index];
}

@end

@interface HROPageControl () <HROPageIconDelegate>

// PRIVATE
@property (nonatomic, strong) NSArray *pageIcons;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HROPageControl

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        self.pageIcons = nil;
        [self setUpScrollView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.pageIcons = nil;
    [self setUpScrollView];
}

#pragma mark - Set Up

- (void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    UIView *subView = self.scrollView;
    UIView *parent = self;
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    
    //Leading
    
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:subView
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parent
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];

    //Trailing
    
    NSLayoutConstraint *trailing = [NSLayoutConstraint
                                   constraintWithItem:subView
                                   attribute:NSLayoutAttributeTrailing
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:parent
                                   attribute:NSLayoutAttributeTrailing
                                   multiplier:1.0f
                                   constant:0.f];
    
    //Bottom
    NSLayoutConstraint *bottom =[NSLayoutConstraint
                                 constraintWithItem:subView
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:parent
                                 attribute:NSLayoutAttributeBottom
                                 multiplier:1.0f
                                 constant:0.f];
    
    //Top
    NSLayoutConstraint *top =[NSLayoutConstraint
                                 constraintWithItem:subView
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                 toItem:parent
                                 attribute:NSLayoutAttributeTop
                                 multiplier:1.0f
                                 constant:0.f];
    
    [parent addConstraint:trailing];
    [parent addConstraint:leading];
    [parent addConstraint:bottom];
    [parent addConstraint:top];
}

#pragma mark - Setters

- (void)setIcons:(NSArray *)icons {
    _icons = icons;
    
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    
    NSInteger iconCount = self.icons.count;
    for(int i = 0; i< iconCount; i++) {
        UIView *pageControlSubView = [[HROPageIcon alloc] initWithDelegate:self
                                                                 withImage:[self.icons objectAtIndex:i]
                                                             withHeight:self.frame.size.height
                                                                atIndex:i];
        [self.scrollView addSubview:pageControlSubView];
        [tmp addObject:pageControlSubView];
    }
    self.pageIcons = [NSArray arrayWithArray:tmp];
}

#pragma mark - Public

- (void)setSelectedIconAtIndex:(NSInteger)index {
    NSAssert(self.pageIcons, @"HROPageControl - Index Beyond the Bounds of the Page Icons");
    
    [UIView animateWithDuration:HROUnderscoreAnimationDuration
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         for (HROPageIcon *currentIcon in self.pageIcons) {
                             currentIcon.underscoreView.backgroundColor = [UIColor clearColor];
                         }
                         HROPageIcon *icon = [self.pageIcons objectAtIndex:index];
                         icon.underscoreView.backgroundColor = self.underscoreColor;
                     }
                     completion:nil];
}

#pragma mark - HROPageIconDelegate

- (void)didSelectOptionForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(didSelectOptionForIndex:)]) {
        [self.delegate didSelectOptionForIndex:index];
    }
}

@end
