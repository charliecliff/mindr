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
#import "g5DayOfTheWeekCondition.h"
#import "g5DateCondition.h"
#import "g5TemperatureCondition.h"
#import "g5WeatherTypeCondition.h"
#import "g5LocationCondition.h"

@protocol g5ConditionDataSource <NSObject>

@required
- (NSDate *)currentDate;
- (NSNumber *)currentTemperature;
- (NSString *)currentWeatherType;
- (CLLocation *)currentLocation;

@end

@interface g5Reminder : NSObject

@property(nonatomic) BOOL isActive;
@property(nonatomic) BOOL pushNotificationHasSound;
@property(nonatomic) BOOL isIconOnlyNotification;

@property(nonatomic, strong) NSString *uid;
@property(nonatomic, strong) NSString *shortExplanation;
@property(nonatomic, strong) NSString *emoticonUnicodeCharacter;
@property(nonatomic, strong) NSString *pushNotificationSoundFileName;

@property(nonatomic, strong) id<g5ConditionDataSource> datasource;

@property(nonatomic, strong, readonly) NSMutableOrderedSet *conditionIDs;

@property(nonatomic, strong) g5TimeCondition *timeCondition;
@property(nonatomic, strong) g5DayOfTheWeekCondition *dayOfTheWeekCondition;
@property(nonatomic, strong) g5DateCondition *dateCondition;
@property(nonatomic, strong) g5TemperatureCondition *temperatureCondition;
@property(nonatomic, strong) g5WeatherTypeCondition *weatherCondition;
@property(nonatomic, strong) g5LocationCondition *locationCondition;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)hasEmoticon;
- (BOOL)hasActiveConditions;
- (BOOL)haveConditionsBeenMeet;

- (NSString *)conditionDescription;

- (g5Condition *)getConditionAtIndex:(NSUInteger)index;
- (g5Condition *)getConditionForID:(NSNumber *)conditionID;
- (void)setCondition:(g5Condition *)condition;

- (NSDictionary *)encodeToDictionary;

@end
