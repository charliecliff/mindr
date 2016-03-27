//
//  g5TemperatureCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"
#import "g5WeatherDatasource.h"

@class g5WeatherManager;

@interface g5TemperatureCondition : g5Condition

@property(nonatomic) NSComparisonResult temperatureComparisonType;
@property(nonatomic, strong) NSNumber *temperature;

- (instancetype)initWithWeatherDatasource:(id<g5WeatherDatasource>)datasource;

@end
