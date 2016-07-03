//
//  g5TemperatureCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

typedef enum {
    g5TemperatureFahrenheit = 0,
    g5TemperatureCelsius
} g5TemperatureUnit;

@class MDRWeatherMonitor;

@interface MDRTemperatureCondition : MDRCondition

@property(nonatomic) g5TemperatureUnit temperatureunit;
@property(nonatomic) NSComparisonResult temperatureComparisonType;
@property(nonatomic, strong) NSNumber *temperature;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
