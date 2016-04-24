//
//  g5OpenWeatherManager.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#define NOTIFICATION_NEW_TEMPERATURE @"NOTIFICATION_NEW_TEMPERATURE"

#import "g5ConditionMonitor.h"
#import "g5Weather.h"
#import "g5WeatherClient.h"
#import "g5LocationManager.h"

extern NSString *const g5WeatherSunny;
extern NSString *const g5WeatherPartlyCloudy;
extern NSString *const g5WeatherCloudy;
extern NSString *const g5WeatherLightRain;
extern NSString *const g5WeatherHeavyRain;
extern NSString *const g5WeatherSeverThunderstorm;

@interface g5WeatherMonitor : g5ConditionMonitor

@property(nonatomic, strong, readonly) g5Weather *currentWeather;

- (NSNumber *)currentTemperature;
- (g5WeatherConditionType)currentWeatherType;

@end