//
//  g5Reminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "g5Condition.h"
#import "g5TimeCondition.h"
#import "g5DateCondition.h"
#import "g5TemperatureCondition.h"
#import "g5WeatherTypeCondition.h"
#import "g5LocationCondition.h"

@protocol g5ConditionDataSource <NSObject>

@required
- (NSDate *)currentTimeOfDay;
- (NSDate *)currentDay;
- (NSNumber *)currentTemperature;
- (g5WeatherConditionType)currentWeatherCondition;
- (CLLocation *)currentLocation;

@end

@interface g5Reminder : NSObject

@property(nonatomic) BOOL isActive;

@property(nonatomic, strong) NSString *reminderDescription;
@property(nonatomic, strong) NSString *emoticonImageName;
@property(nonatomic, strong) id<g5ConditionDataSource> datasource;

@property(nonatomic, strong, readonly) NSString *uid;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *conditionIDs;

@property(nonatomic, strong) g5TimeCondition *timeCondition;
@property(nonatomic, strong) g5DateCondition *dateCondition;
@property(nonatomic, strong) g5TemperatureCondition *temperatureCondition;
@property(nonatomic, strong) g5WeatherTypeCondition *weatherCondition;
@property(nonatomic, strong) g5LocationCondition *locationCondition;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)haveConditionsBeenMeet;

- (g5Condition *)getConditionAtIndex:(NSUInteger)index;
- (g5Condition *)getConditionForID:(NSNumber *)conditionID;

- (void)setCondition:(g5Condition *)condition;

- (NSDictionary *)encodeToDictionary;

@end
