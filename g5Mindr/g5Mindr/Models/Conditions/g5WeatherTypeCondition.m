//
//  g5WeatherTypeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5WeatherTypeCondition.h"

@interface g5WeatherTypeCondition ()

@property(nonatomic) g5WeatherConditionType weatherType;

@end

@implementation g5WeatherTypeCondition

#pragma mark - Init

- (instancetype)initWithWeatherDatasource:(id<g5WeatherDatasource>)datasource; {
    self = [super init];
    if (self != nil) {
        self.datasource  = datasource;
        self.uid         = [NSNumber numberWithInt:g5ConditionIDWeather];
        self.type        = g5WeatherType;
        self.weatherType = -1;

    }
    return self;
}

#pragma mark - Over Ride

- (BOOL)isValid {
    return NO;
}

- (NSString *)detailsText {
    return @"_details_";
}

- (NSString *)placeholderText {
    return @"WEATHER";
}
@end
