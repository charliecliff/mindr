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

#import "g5WeatherMonitor.h"
#import "g5LocationManager.h"

#define KEY_ID                    @"KEY_ID"
#define KEY_TIME_CONDITION        @"KEY_TIME_CONDITION"
#define KEY_DATE_CONDITION        @"KEY_DATE_CONDITION"
#define KEY_WEATHER_CONDITION     @"KEY_WEATHER_CONDITION"
#define KEY_TEMPERATURE_CONDITION @"KEY_TEMPERATURE_CONDITION"
#define KEY_LOCATION_CONDITION    @"KEY_LOCATION_CONDITION"

@interface g5Reminder ()

@property(nonatomic, strong, readwrite) NSString *uid;
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
        [self generateUID];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self= [self init];
    if (self != nil) {
        [self parseDictionary:dictionary];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpConditionsArray {
    self.timeCondition        = [[g5TimeCondition alloc] init];
    self.dateCondition        = [[g5DateCondition alloc] initWithDates:nil];
    self.temperatureCondition = [[g5TemperatureCondition alloc] init];
    self.weatherCondition     = [[g5WeatherTypeCondition alloc] init];
    self.locationCondition    = [[g5LocationCondition alloc] init];
    
    [self setCondition:self.timeCondition];
    [self setCondition:self.dateCondition];
    [self setCondition:self.temperatureCondition];
    [self setCondition:self.weatherCondition];
    [self setCondition:self.locationCondition];
}

- (void)generateUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    self.uid = (__bridge_transfer NSString *)uuidStringRef;
}

#pragma mark - Getters

- (BOOL)haveConditionsBeenMeet {
    BOOL timeIsValid             = [self.timeCondition isValidDate:[self.datasource currentTimeOfDay]];
    BOOL dateIsValid             = [self.dateCondition isValidDate:[self.datasource currentDay]];
    BOOL temperatureIsValid      = [self.temperatureCondition isValidTemperature:[self.datasource currentTemperature]];
    BOOL weatherConditionIsValid = [self.weatherCondition isValidWeatherType:[self.datasource currentWeatherCondition]];
    BOOL locationIsValid         = [self.locationCondition isValidLocation:[self.datasource currentLocation]];
    
    return (timeIsValid && dateIsValid && temperatureIsValid && weatherConditionIsValid && locationIsValid);
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

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.uid = [dictionary objectForKey:KEY_ID];
    
    NSDictionary *timeDictionary = [dictionary objectForKey:KEY_TIME_CONDITION];
    self.timeCondition = [[g5TimeCondition alloc] initWithDictionary:timeDictionary];

    NSDictionary *dateDictionary = [dictionary objectForKey:KEY_DATE_CONDITION];
    self.dateCondition = [[g5DateCondition alloc] initWithDictionary:dateDictionary];
    
    NSDictionary *temperatureDictionary = [dictionary objectForKey:KEY_TEMPERATURE_CONDITION];
    self.temperatureCondition = [[g5TemperatureCondition alloc] initWithDictionary:temperatureDictionary];
    
    NSDictionary *weatherDictionary = [dictionary objectForKey:KEY_WEATHER_CONDITION];
    self.weatherCondition = [[g5WeatherTypeCondition alloc] initWithDictionary:weatherDictionary];
    
    NSDictionary *locationDictionary = [dictionary objectForKey:KEY_LOCATION_CONDITION];
    self.locationCondition = [[g5LocationCondition alloc] initWithDictionary:locationDictionary];
    
    [self setCondition:self.timeCondition];
    [self setCondition:self.dateCondition];
    [self setCondition:self.temperatureCondition];
    [self setCondition:self.weatherCondition];
    [self setCondition:self.locationCondition];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.uid forKey:KEY_ID];
    
    NSDictionary *timeDictionary = [self.timeCondition encodeToDictionary];
    [dictionary setObject:timeDictionary forKey:KEY_TIME_CONDITION];
    
    NSDictionary *dateDictionary = [self.dateCondition encodeToDictionary];
    [dictionary setObject:dateDictionary forKey:KEY_DATE_CONDITION];
    
    NSDictionary *temperatureDictionary = [self.temperatureCondition encodeToDictionary];
    [dictionary setObject:temperatureDictionary forKey:KEY_TEMPERATURE_CONDITION];
    
    NSDictionary *weatherDictionary = [self.weatherCondition encodeToDictionary];
    [dictionary setObject:weatherDictionary forKey:KEY_WEATHER_CONDITION];
    
    NSDictionary *locationDictionary = [self.locationCondition encodeToDictionary];
    [dictionary setObject:locationDictionary forKey:KEY_LOCATION_CONDITION];
    
    return dictionary;
}

@end





