//
//  g5ConditionTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class g5Condition;

@protocol g5ConditionCellDelegate <NSObject>

@required
- (void)g5Condition:(g5Condition *)condition didSetActive:(BOOL)active;

@end

@interface g5ConditionTableViewCell : UITableViewCell

@property(nonatomic, strong) id<g5ConditionCellDelegate> delegate;

- (void)configureForActiveCondition:(g5Condition *)condition;
- (void)configureForInActiveCondition:(g5Condition *)condition;

@end
