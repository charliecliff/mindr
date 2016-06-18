//
//  g5ConditionViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "mindrBounceNavigationViewController.h"

@class MDRCondition;

@protocol g5ConditionDelegate <NSObject>

@required
- (void)didUpdateCondition:(MDRCondition *)condition;

@end

@interface g5ConditionViewController : UIViewController <HROBounceNavigationDelegate>

@property(nonatomic, strong) MDRCondition *condition;
@property(nonatomic, strong) id<g5ConditionDelegate> delegate;

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCondition:(MDRCondition *)condition;

@end
