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

- (BOOL)isValidWeatherType:(NSString *)weatherType;
- (BOOL)containsWeatherType:(NSString *)weatherType;

- (void)removeWeatherType:(NSString *)weatherType;
- (void)addWeatherType:(NSString *)weatherType;

@end
