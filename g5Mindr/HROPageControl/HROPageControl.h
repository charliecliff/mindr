//
//  HROPageControl.h
//  g5Mindr
//
//  Created by Charles Cliff on 7/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HROPageControl;

@protocol HROPageControlDelegate <NSObject>

@required
/**
 *
 */
- (void)didSelectOptionForIndex:(NSInteger)index;

@end

@interface HROPageControl : UIView

/**
 *
 */
@property (nonatomic, strong) NSArray *icons;

/**
 *
 */
@property (nonatomic, strong) UIColor *underscoreColor;

/**
 *
 */
@property (nonatomic, strong) UIColor *unselectedColor;

/**
 *
 */
@property(nonatomic, strong) IBOutlet id<HROPageControlDelegate> delegate;

/**
 *
 */
- (void)setSelectedIconAtIndex:(NSInteger)index;

@end
