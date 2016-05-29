//
//  g5DayOfTheWeekCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"

@interface g5DayOfTheWeekCondition : g5Condition

@property(nonatomic, strong, readonly) NSString *dayOfTheWeekString;
@property(nonatomic, strong, readonly) NSMutableSet *daysOfTheWeek;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setDayOfTheWeek:(NSInteger)weekday;
- (void)removeDayOfTheWeek:(NSInteger)weekday;
- (BOOL)containsDayOfTheWeek:(NSInteger)weekday;

- (BOOL)isValidDate:(NSDate *)date;

@end
