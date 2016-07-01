//
//  g5WeatherTypeCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

extern NSString *const g5WeatherSunny;
extern NSString *const g5WeatherPartlyCloudy;
extern NSString *const g5WeatherMostlyCloudy;
extern NSString *const g5WeatherLightRain;
extern NSString *const g5WeatherHeavyRain;
extern NSString *const g5WeatherSeverThunderstorm;
extern NSString *const g5WeatherFoggy;
extern NSString *const g5WeatherWindy;
extern NSString *const g5WeatherSnowy;

@interface g5WeatherTypeCondition : MDRCondition

- (BOOL)containsWeatherType:(NSString *)weatherType;
- (void)removeWeatherType:(NSString *)weatherType;
- (void)addWeatherType:(NSString *)weatherType;

@end
