//
//  g5WeatherTypeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRWeatherTypeCondition.h"

static NSString *const kMDRConditionWeatherTypes = @"weather_types";

NSString *const g5WeatherSunny              = @"weather_mostlysunny";
NSString *const g5WeatherPartlyCloudy       = @"weather_partlycloudy";
NSString *const g5WeatherMostlyCloudy       = @"weather_mostlycloudy";
NSString *const g5WeatherLightRain          = @"weather_rainy";
NSString *const g5WeatherHeavyRain          = @"weather_reallyrainy";
NSString *const g5WeatherSeverThunderstorm  = @"weather_thunderstorms";
NSString *const g5WeatherFoggy              = @"weather_foggy";
NSString *const g5WeatherWindy              = @"weather_windy";
NSString *const g5WeatherSnowy              = @"weather_snowy";

@interface MDRWeatherTypeCondition ()

@property(nonatomic, strong) NSMutableSet *weatherTypes;

@end

@implementation MDRWeatherTypeCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        self.type        = g5WeatherType;
        self.weatherTypes= [[NSMutableSet alloc] init];
        [self parseDictionary:dictionary[kMDRConditionAttributes]];
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
            NSString *weatherString = [MDRWeatherTypeCondition descriptionFromWeatherType:currentWeatherType];
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, weatherString];
        }
        return resultString;
    }
    return @"WEATHER";
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
    NSArray *arrayOfWeatherTypes = [dictionary objectForKey:kMDRConditionWeatherTypes];
    self.weatherTypes = [NSMutableSet setWithArray:arrayOfWeatherTypes];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:self.weatherTypes.allObjects forKey:kMDRConditionWeatherTypes];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
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
