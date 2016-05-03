//
//  g5WeatherTypeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeCondition.h"

#define KEY_CONDITION_WEATHER_TYPE @"KEY_CONDITION_WEATHER_TYPE"

@interface g5WeatherTypeCondition ()

@property(nonatomic) kWeatherType weatherType;

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
        self.weatherType = -1;
    }
    return self;
}

#pragma mark - Over Ride

- (BOOL)isValidWeatherType:(kWeatherType)weatherType {
    return (weatherType == self.weatherType);
}

- (NSString *)detailsText {
    return @"_details_";
}

- (NSString *)placeholderText {
    return @"WEATHER";
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSNumber *weatherTypeNumber = [dictionary objectForKey:KEY_CONDITION_WEATHER_TYPE];
    self.weatherType = [weatherTypeNumber intValue];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    [dictionary setObject:[NSNumber numberWithInt:self.weatherType] forKey:KEY_CONDITION_WEATHER_TYPE];
    return dictionary;
}

@end
