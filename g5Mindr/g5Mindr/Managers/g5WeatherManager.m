//
//  g5OpenWeatherManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "g5WeatherManager.h"
#import "g5Weather.h"
#import "g5WeatherClient.h"
#import "g5OpenWeatherClient.h"

#import "g5LocationManager.h"

@interface g5WeatherManager ()

@property(nonatomic, strong) g5Weather *previousWeather;
@property(nonatomic, strong, readwrite) g5Weather *currentWeather;

@property(nonatomic, strong) id<g5WeatherClient> weatherClient;

@end

@implementation g5WeatherManager

#pragma mark - Singleton

+ (g5WeatherManager *)sharedManager
{
    static g5WeatherManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (g5WeatherManager *)init
{
    self = [super init];
    if (self != nil)
    {
        self.weatherClient = [[g5OpenWeatherClient alloc] init]; // Weather Source
    }
    return self;
}

#pragma mark - Set Up

#pragma mark - Business Logic

- (void)updateWeatherCondition:(g5Weather *)newWeather
{
    self.previousWeather = self.currentWeather;
    self.currentWeather  = newWeather;
    [self determineTemperatureChange];
}

#pragma mark - Weather Notifications

- (void)determineWeatherConditionIDChange
{
    
}

- (void)determineTemperatureChange
{
    if ( self.previousWeather.temperature != self.currentWeather.temperature ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NEW_TEMPERATURE object:nil];
    }
}

#pragma mark - Weather Source Calls

- (void)updateCurrentWeather
{
    CLLocation *currentLocation = [[g5LocationManager sharedManager] currentLocation];
    
    __block __typeof(self)blockSelf = self;
    [self.weatherClient getCurrentWeatherForLocation:currentLocation withSuccess:^(NSDictionary *respsonseDictionary) {
        g5Weather *newWeatherCondition = [MTLJSONAdapter modelOfClass:[g5Weather class] fromJSONDictionary:respsonseDictionary error:nil];
        [blockSelf updateWeatherCondition:newWeatherCondition];
    } withFailure:nil];
}

#pragma mark - g5WeatherSource

- (NSNumber *)currentTemperature {
    return self.currentWeather.temperature;
}

- (g5WeatherConditionType)currentWeatherType {
    return nil;
}

@end
