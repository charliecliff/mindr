//
//  g5WeatherTypeCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"
#import "g5WeatherDatasource.h"

@interface g5WeatherTypeCondition : g5Condition

@property(nonatomic, strong) id<g5WeatherDatasource> datasource;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithWeatherDatasource:(id<g5WeatherDatasource>)datasource;

@end
