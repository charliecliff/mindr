//
//  g5TemperatureCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"

typedef enum {
    g5TemperatureFahrenheit = 0,
    g5TemperatureCelsius
} g5TemperatureUnit;

@class g5WeatherMonitor;

@interface g5TemperatureCondition : g5Condition

@property(nonatomic) g5TemperatureUnit temperatureunit;
@property(nonatomic) NSComparisonResult temperatureComparisonType;
@property(nonatomic, strong) NSNumber *temperature;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isValidTemperature:(NSNumber *)temperature;

@end
