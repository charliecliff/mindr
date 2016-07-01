//
//  g5TemperatureCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperatureCondition.h"

#define KEY_CONDITION_TEMPERATURE @"KEY_CONDITION_TEMPERATURE"

static NSString *const kMDRTemperature               = @"temperature";
static NSString *const kMDRTemperatureComparisonType = @"comparison_type";
static NSString *const kMDRTemperatureUnit           = @"unit";

@implementation g5TemperatureCondition

#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *superDictionary = [super JSONKeyPathsByPropertyKey];
    return [superDictionary mtl_dictionaryByAddingEntriesFromDictionary:@{@"temperatureunit":kMDRTemperatureUnit,
                                                                          @"temperatureComparisonType":kMDRTemperatureComparisonType,
                                                                          @"temperature":kMDRTemperature}];
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type        = g5TemperatureType;
        self.temperature = [NSNumber numberWithFloat:67.0];
        self.temperatureComparisonType = NSOrderedSame;
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
        NSString *resultString = @"When it's";
        if (self.temperatureComparisonType == NSOrderedAscending) {
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, @"above"];
        }
        else if (self.temperatureComparisonType == NSOrderedDescending) {
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, @"below"];
        }
        else if (self.temperatureComparisonType == NSOrderedSame) {
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, @"exactly"];
        }
        
        resultString = [NSString stringWithFormat:@"%@ %@\u00b0", resultString, self.temperature];
        
        if (self.temperatureunit == g5TemperatureFahrenheit) {
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, @"F"];
        }
        else if (self.temperatureunit == g5TemperatureCelsius) {
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, @"C"];
        }
        
        return resultString;
    }
    return @"TEMPERATURE";
}

@end
