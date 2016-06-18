//
//  g5ConditionTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRCondition;

@protocol g5ConditionCellDelegate <NSObject>

@required
- (void)g5Condition:(MDRCondition *)condition didSetActive:(BOOL)active;

@end

@interface g5ConditionTableViewCell : UITableViewCell

@property(nonatomic, strong) id<g5ConditionCellDelegate> delegate;

- (void)configureForActiveCondition:(MDRCondition *)condition;
- (void)configureForInActiveCondition:(MDRCondition *)condition;

@end
