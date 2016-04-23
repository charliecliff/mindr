//
//  g5Reminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "g5Condition.h"

@class g5TimeCondition;
@class g5DateCondition;
@class g5TemperatureCondition;
@class g5WeatherTypeCondition;
@class g5LocationCondition;

@interface g5Reminder : NSObject

@property(nonatomic) BOOL isActive;

@property(nonatomic, strong, readonly) NSString *uid;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *conditionIDs;

@property(nonatomic, strong) g5TimeCondition *timeCondition;
@property(nonatomic, strong) g5DateCondition *dateCondition;
@property(nonatomic, strong) g5TemperatureCondition *temperatureCondition;
@property(nonatomic, strong) g5WeatherTypeCondition *weatherCondition;
@property(nonatomic, strong) g5LocationCondition *locationCondition;

@property(nonatomic, strong) NSString *emoticonImageName;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)haveConditionsBeenMeet;

- (g5Condition *)getConditionAtIndex:(NSUInteger)index;
- (g5Condition *)getConditionForID:(NSNumber *)conditionID;

- (void)setCondition:(g5Condition *)condition;

- (NSDictionary *)encodeToDictionary;

@end
