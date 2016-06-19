//
//  g5WeatherTypeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeCondition.h"
#import "MDRWeatherMonitor.h"

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
        self.weatherTypes= [[NSMutableSet alloc] initWithObjects:g5WeatherSunny, nil];
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
        NSString *resultString = @"When it's";
        for (NSString *currentWeatherType in self.weatherTypes) {
            NSString *weatherString = [g5WeatherTypeCondition descriptionFromWeatherType:currentWeatherType];
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, weatherString];
        }
        return resultString;
    }
    return @"WEATHER";
}

#pragma mark - Validation

- (BOOL)validateWithContext:(MDRReminderContext *)context {
    return [self.weatherTypes containsObject:context.currentWeatherType];
}

#pragma mark - Weather Type Management

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

#pragma mark - Class Helpers

+ (NSString *)descriptionFromWeatherType:(NSString *)weatherType {
    if ([weatherType isEqualToString:g5WeatherSunny]) {
        return @"Sunny";
    }
    else if ([weatherType isEqualToString:g5WeatherPartlyCloudy]) {
        return @"Partly Cloudy";
    }
    else if ([weatherType isEqualToString:g5WeatherMostlyCloudy]) {
        return @"Mostly Cloudy";
    }
    else if ([weatherType isEqualToString:g5WeatherLightRain]) {
        return @"Lightly Raining";
    }
    else if ([weatherType isEqualToString:g5WeatherHeavyRain]) {
        return @"Heavily Raining";
    }
    else if ([weatherType isEqualToString:g5WeatherSeverThunderstorm]) {
        return @"Stormy";
    }
    else if ([weatherType isEqualToString:g5WeatherFoggy]) {
        return @"Foggy";
    }
    else if ([weatherType isEqualToString:g5WeatherWindy]) {
        return @"Windy";
    }
    else if ([weatherType isEqualToString:g5WeatherSnowy]) {
        return @"Snowing";
    }
    return nil;
}

@end
