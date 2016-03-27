//
//  g5TemperatureCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperatureCondition.h"

@interface g5TemperatureCondition ()

@property(nonatomic, strong) id<g5WeatherDatasource> datasource;

@end

@implementation g5TemperatureCondition

#pragma mark - Init

- (instancetype)initWithWeatherDatasource:(id<g5WeatherDatasource>)datasource;
{
    self = [super init];
    if (self != nil) {
        self.datasource  = datasource;
        self.uid         = [NSNumber numberWithInt:g5ConditionIDTemperature];
        self.type        = g5TemperatureType;
        self.temperature = [NSNumber numberWithFloat:67.0];
        self.temperatureComparisonType = NSOrderedSame;
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
    return @"TEMPERATURE";
}

@end
