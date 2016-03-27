//
//  g5Reminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "g5Condition.h"

@interface g5Reminder : NSObject

@property(nonatomic) BOOL isActive;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *conditionIDs;

- (BOOL)haveConditionsBeenMeet;

- (g5Condition *)getConditionAtIndex:(NSUInteger)index;
- (g5Condition *)getConditionForID:(NSNumber *)conditionID;

- (void)setCondition:(g5Condition *)condition;

@end
