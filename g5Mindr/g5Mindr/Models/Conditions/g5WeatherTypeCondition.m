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
        self.type        = g5WeatherType;
        self.weatherTypes= [[NSMutableSet alloc] init];
        
        [self parseDictionary:dictionary];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type        = g5WeatherType;
        self.weatherTypes= [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    return @"WEATHER";
}

#pragma mark - Validation

- (BOOL)isValidWeatherType:(NSString *)weatherType {
    return [self.weatherTypes containsObject:weatherType];
}

- (BOOL)containsWeatherType:(NSString *)weatherType {
    return [self.weatherTypes containsObject:weatherType];
}

- (void)removeWeatherType:(NSString *)weatherType {
    [self.weatherTypes removeObject:weatherType];
}

- (void)addWeatherType:(NSString *)weatherType {
    [self.weatherTypes addObject:weatherType];
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
