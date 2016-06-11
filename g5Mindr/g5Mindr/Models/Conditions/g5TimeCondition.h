//
//  g5TimeCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"

typedef enum {
    MDRTimeAM = 0,
    MDRTimePM,
} MDRTimeMeridian;

@interface g5TimeCondition : g5Condition

@property(nonatomic) NSInteger hour;
@property(nonatomic) NSInteger minute;
@property(nonatomic) MDRTimeMeridian meridian;

@property(nonatomic, readonly) NSInteger dateComponentForHour;
@property(nonatomic, readonly) NSInteger dateComponentForMinute;

@property(nonatomic, readonly) NSTimeInterval timeOfDayInSeconds;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setDate:(NSDate *)date;

- (BOOL)isValidDate:(NSDate *)date;

@end
