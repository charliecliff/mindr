//
//  g5OpenWeatherManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "MDRWeatherMonitor.h"
#import "g5Weather.h"
#import "g5WeatherClient.h"
#import "g5OpenWeatherClient.h"

#import "MDRLocationMonitor.h"

NSString *const g5WeatherSunny              = @"weather_mostlysunny";
NSString *const g5WeatherPartlyCloudy       = @"weather_partlycloudy";
NSString *const g5WeatherMostlyCloudy       = @"weather_mostlycloudy";
NSString *const g5WeatherLightRain          = @"weather_rainy";
NSString *const g5WeatherHeavyRain          = @"weather_reallyrainy";
NSString *const g5WeatherSeverThunderstorm  = @"weather_thunderstorms";
NSString *const g5WeatherFoggy              = @"weather_foggy";
NSString *const g5WeatherWindy              = @"weather_windy";
NSString *const g5WeatherSnowy              = @"weather_snowy";

@interface MDRWeatherMonitor () {
    NSString *currentWeatherType;
}

@property(nonatomic, strong) g5Weather *previousWeather;
@property(nonatomic, strong, readwrite) g5Weather *currentWeather;

@property(nonatomic, strong) id<g5WeatherClient> weatherClient;

@end

@implementation MDRWeatherMonitor

#pragma mark - Singleton

+ (MDRWeatherMonitor *)sharedMonitor {
    static MDRWeatherMonitor *_sharedMonitor = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedMonitor = [[self alloc] init];
    });
    return _sharedMonitor;
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.weatherClient = [[g5OpenWeatherClient alloc] init]; // Weather Source
    }
    return self;
}

#pragma mark - Business Logic

- (void)updateMonitoredCondition {
    CLLocation *currentLocation = [[MDRLocationMonitor sharedManager] currentLocation];
    
    __block __typeof(self)blockSelf = self;
    [self.weatherClient getCurrentWeatherForLocation:currentLocation
                                         withSuccess:^(NSDictionary *respsonseDictionary) {
                                             g5Weather *newWeather = [MTLJSONAdapter modelOfClass:[g5Weather class]
                                                                               fromJSONDictionary:respsonseDictionary
                                                                                            error:nil];
                                             blockSelf.currentWeather = newWeather;
                                         }
                                         withFailure:nil];
}

#pragma mark - g5WeatherSource

- (NSNumber *)currentTemperature {
    return self.currentWeather.temperature;
}

- (NSString *)currentWeatherType {
    return currentWeatherType;
}

@end
