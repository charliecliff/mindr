//
//  g5Reminder.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Reminder.h"
#import "g5DateCondition.h"
#import "g5TimeCondition.h"
#import "g5LocationCondition.h"
#import "g5WeatherTypeCondition.h"
#import "g5TemperatureCondition.h"

#import "g5WeatherManager.h"
#import "g5LocationManager.h"

@interface g5Reminder ()

@property(nonatomic, strong, readwrite) NSMutableOrderedSet *conditionIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *conditions;

@end

@implementation g5Reminder

#pragma mark - Init

- (instancetype)init {
    self= [super init];
    if (self != nil) {
        
        self.isActive = NO;
        self.conditionIDs = [[NSMutableOrderedSet alloc] init];
        self.conditions   = [[NSMutableDictionary alloc] init];
        
        [self setUpConditionsArray];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpConditionsArray {
    g5TimeCondition *timeCondition = [[g5TimeCondition alloc] initWithEventDatasource:nil];
    [self setCondition:timeCondition];
    
    g5DateCondition *dateCondition = [[g5DateCondition alloc] initWithEventDatasource:nil];
    [self setCondition:dateCondition];
    
    g5WeatherTypeCondition *weatherCondition = [[g5WeatherTypeCondition alloc] initWithWeatherDatasource:[g5WeatherManager sharedManager]];
    [self setCondition:weatherCondition];

    g5TemperatureCondition *temperatureCondition = [[g5TemperatureCondition alloc] initWithWeatherDatasource:[g5WeatherManager sharedManager]];
    [self setCondition:temperatureCondition];

    g5LocationCondition *locationCondition = [[g5LocationCondition alloc] initWithLocationDatasource:[g5LocationManager sharedManager]];
    [self setCondition:locationCondition];
}

#pragma mark - Getters

- (BOOL)haveConditionsBeenMeet {
    return NO;
}

- (g5Condition *)getConditionAtIndex:(NSUInteger)index {
    NSNumber *conditionUID = [self.conditionIDs objectAtIndex:index];
    g5Condition *selectedCondition = [self.conditions objectForKey:conditionUID];
    return selectedCondition;
}

- (g5Condition *)getConditionForID:(NSNumber *)conditionID {
    g5Condition *selectedCondition = [self.conditions objectForKey:conditionID];
    return selectedCondition;
}

#pragma mark - Setters

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
}

- (void)setCondition:(g5Condition *)condition {
    [self.conditions setObject:condition forKey:condition.uid];
    [self.conditionIDs addObject:condition.uid];
}

@end
