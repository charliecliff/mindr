//
//  g5OpenWeatherManager.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#define NOTIFICATION_NEW_TEMPERATURE @"NOTIFICATION_NEW_TEMPERATURE"

#import "g5Weather.h"
#import "g5WeatherClient.h"
#import "MDRLocationMonitor.h"

extern NSString *const g5WeatherSunny;
extern NSString *const g5WeatherPartlyCloudy;
extern NSString *const g5WeatherMostlyCloudy;
extern NSString *const g5WeatherLightRain;
extern NSString *const g5WeatherHeavyRain;
extern NSString *const g5WeatherSeverThunderstorm;
extern NSString *const g5WeatherFoggy;
extern NSString *const g5WeatherWindy;
extern NSString *const g5WeatherSnowy;

@interface MDRWeatherMonitor : NSObject

@property(nonatomic, strong, readonly) g5Weather *currentWeather;

@property(nonatomic, strong, readonly) NSNumber *currentTemperature;
@property(nonatomic, strong, readonly) NSString *currentWeatherType;

+ (MDRWeatherMonitor *)sharedMonitor;

@end
