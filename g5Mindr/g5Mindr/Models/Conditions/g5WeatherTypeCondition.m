//
//  g5WeatherTypeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeCondition.h"

#define KEY_CONDITION_WEATHER_TYPES @"KEY_CONDITION_WEATHER_TYPES"

@interface g5WeatherTypeCondition ()

@property(nonatomic, strong) NSMutableSet *weatherTypes;

@end

@implementation g5WeatherTypeCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.uid         = [NSNumber numberWithInt:g5ConditionIDWeather];
        self.type        = g5WeatherType;
        self.weatherTypes= [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)placeholderText {
    return @"WEATHER";
}

#pragma mark - Validation

- (BOOL)isValidWeatherType:(kWeatherType)weatherType {
    return [self.weatherTypes containsObject:[NSNumber numberWithInt:weatherType]];
}

- (BOOL)containsWeatherType:(kWeatherType)weatherType {
    return [self.weatherTypes containsObject:[NSNumber numberWithInt:weatherType]];
}

- (void)removeWeatherType:(kWeatherType)weatherType {
    [self.weatherTypes addObject:[NSNumber numberWithInt:weatherType]];
}

- (void)addWeatherType:(kWeatherType)weatherType {
    [self.weatherTypes removeObject:[NSNumber numberWithInt:weatherType]];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfWeatherTypes = [dictionary objectForKey:KEY_CONDITION_WEATHER_TYPES];
    self.weatherTypes = [NSMutableSet setWithArray:arrayOfWeatherTypes];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    [dictionary setObject:self.weatherTypes.allObjects forKey:KEY_CONDITION_WEATHER_TYPES];
    return dictionary;
}

@end
