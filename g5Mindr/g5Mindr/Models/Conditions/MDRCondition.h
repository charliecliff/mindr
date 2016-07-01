//
//  g5Condition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum {
    g5ConditionIDDate = 0,
    g5ConditionIDTime,
    g5ConditionIDWeather,
    g5ConditionIDTemperature,
    g5ConditionIDLocation
} g5ConditionID;

extern NSString *const g5NoType;
extern NSString *const g5DateType;
extern NSString *const g5TimeType;
extern NSString *const g5DayOfTheWeekType;
extern NSString *const g5WeatherType;
extern NSString *const g5TemperatureType;
extern NSString *const g5LocationType;

@interface MDRCondition : MTLModel <MTLJSONSerializing>

/**
 
 */
@property(nonatomic) BOOL isActive;

/**
 
 */
@property(nonatomic) BOOL isLocked;

/**
 
 */
@property(nonatomic, strong) NSString *uid;

/**
 
 */
@property(nonatomic, strong) NSString *type;

- (NSString *)conditionDescription;
- (NSString *)conditionIconName;

@end
