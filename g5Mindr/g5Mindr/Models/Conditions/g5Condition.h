//
//  g5Condition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    g5ConditionIDDate = 0,
    g5ConditionIDTime,
    g5ConditionIDWeather,
    g5ConditionIDTemperature,
    g5ConditionIDLocation
} g5ConditionID;

extern NSString *const g5DateType;
extern NSString *const g5TimeType;
extern NSString *const g5WeatherType;
extern NSString *const g5TemperatureType;
extern NSString *const g5LocationType;

@interface g5Condition : NSObject

@property(nonatomic) BOOL isActive;
@property(nonatomic) BOOL isLocked;
@property(nonatomic, strong) NSNumber *uid;
@property(nonatomic, strong) NSString *type;

- (BOOL)isValid;
- (NSString *)detailsText;
- (NSString *)placeholderText;

@end
