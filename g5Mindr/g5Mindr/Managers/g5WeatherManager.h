//
//  g5OpenWeatherManager.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#define NOTIFICATION_NEW_TEMPERATURE @"NOTIFICATION_NEW_TEMPERATURE"

#import <Foundation/Foundation.h>
#import "g5WeatherClient.h"
#import "g5WeatherDatasource.h"
#import "g5LocationDatasource.h"

extern NSString *const g5WeatherSunny;
extern NSString *const g5WeatherPartlyCloudy;
extern NSString *const g5WeatherCloudy;
extern NSString *const g5WeatherLightRain;
extern NSString *const g5WeatherHeavyRain;
extern NSString *const g5WeatherSeverThunderstorm;

@import CoreLocation;

@class g5Weather;

@interface g5WeatherManager : NSObject <g5WeatherDatasource>

@property(nonatomic, strong, readonly) g5Weather *currentWeather;

+ (g5WeatherManager *)sharedManager;

- (void)updateCurrentWeather;

@end
