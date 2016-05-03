//
//  g5WeatherTypeCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"
#import "g5Weather.h"

@interface g5WeatherTypeCondition : g5Condition

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isValidWeatherType:(kWeatherType)weatherType;
- (BOOL)containsWeatherType:(kWeatherType)weatherType;

- (void)removeWeatherType:(kWeatherType)weatherType;
- (void)addWeatherType:(kWeatherType)weatherType;

@end
