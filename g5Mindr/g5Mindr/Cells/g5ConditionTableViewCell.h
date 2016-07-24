//
//  g5ConditionTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRCondition;
@class g5ConditionTableViewCell;

@protocol g5ConditionCellDelegate <NSObject>
@required
- (void)conditionCell:(g5ConditionTableViewCell *)cell didSetActive:(BOOL)active;
@end

@interface g5ConditionTableViewCell : UITableViewCell

@property(nonatomic, strong, readonly) MDRCondition *condition;

@property(nonatomic, strong) id<g5ConditionCellDelegate> delegate;

- (void)configureForCondition:(MDRCondition *)condition;

- (void)setConditionActive:(BOOL)isActive;

@end
