//
//  g5OpenWeatherManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "g5WeatherMonitor.h"
#import "g5Weather.h"
#import "g5WeatherClient.h"
#import "g5OpenWeatherClient.h"

#import "g5LocationManager.h"

NSString *const g5WeatherSunny              = @"sunny";
NSString *const g5WeatherPartlyCloudy       = @"partly_cloudy";
NSString *const g5WeatherCloudy             = @"cloudy";
NSString *const g5WeatherLightRain          = @"light_rain";
NSString *const g5WeatherHeavyRain          = @"heavy_rain";
NSString *const g5WeatherSeverThunderstorm  = @"severe_thunderstorm";

@interface g5WeatherMonitor () {
    g5WeatherConditionType currentWeatherCondition;
}

@property(nonatomic, strong) g5Weather *previousWeather;
@property(nonatomic, strong, readwrite) g5Weather *currentWeather;

@property(nonatomic, strong) id<g5WeatherClient> weatherClient;

@end

@implementation g5WeatherMonitor

#pragma mark - Init

- (instancetype)initWithDelegate:(id<g5ConditionMonitorDelegate>)delegate; {
    self = [super initWithDelegate:delegate];
    if (self != nil) {
        self.weatherClient = [[g5OpenWeatherClient alloc] init]; // Weather Source
    }
    return self;
}

#pragma mark - Set Up

#pragma mark - Business Logic

- (void)updateMonitoredCondition {
    CLLocation *currentLocation = [[g5LocationManager sharedManager] currentLocation];
    
    __block __typeof(self)blockSelf = self;
    [self.weatherClient getCurrentWeatherForLocation:currentLocation
                                         withSuccess:^(NSDictionary *respsonseDictionary) {
                                             g5Weather *newWeather = [MTLJSONAdapter modelOfClass:[g5Weather class]
                                                                               fromJSONDictionary:respsonseDictionary
                                                                                            error:nil];
                                             [blockSelf updateTemperatureForWeather:newWeather];
                                             [blockSelf updateConditionForWeather:newWeather];
                                         }
                                         withFailure:nil];
}

#pragma mark - Weather Updates

- (void)updateTemperatureForWeather:(g5Weather *)weather {
    if ( self.previousWeather.condition != self.currentWeather.condition ) {
        [self.delegate didUpdateCondition:self];
    }
}

- (void)updateConditionForWeather:(g5Weather *)weather {
    if ( self.previousWeather.temperature != self.currentWeather.temperature ) {
        [self.delegate didUpdateCondition:self];
    }
}

#pragma mark - g5WeatherSource

- (NSNumber *)currentTemperature {
    return self.currentWeather.temperature;
}

- (g5WeatherConditionType)currentWeatherType {
    return currentWeatherCondition;
}

@end
