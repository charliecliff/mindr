//
//  g5DayOfTheWeekCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

@interface g5DayOfTheWeekCondition : MDRCondition

@property(nonatomic, strong, readonly) NSString *dayOfTheWeekString;
@property(nonatomic, strong, readonly) NSMutableSet *daysOfTheWeek;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setDayOfTheWeek:(NSInteger)weekday;
- (void)removeDayOfTheWeek:(NSInteger)weekday;
- (BOOL)containsDayOfTheWeek:(NSInteger)weekday;

@end
