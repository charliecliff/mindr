//
//  g5TemperatureCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperatureCondition.h"

#define KEY_CONDITION_TEMPERATURE @"KEY_CONDITION_TEMPERATURE"

@implementation g5TemperatureCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary];
    }
    return self;
}

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

#pragma mark - Validation

- (BOOL)validateWithContext:(MDRReminderContext *)context {
    if ( ([self.temperature integerValue]< ([context.currentTemperature integerValue]+ 1))  &&
        ([self.temperature integerValue]> ([context.currentTemperature integerValue] - 1))) {
        return YES;
    }
    return NO;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.temperature = [dictionary objectForKey:KEY_CONDITION_TEMPERATURE];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    [dictionary setObject:self.temperature forKey:KEY_CONDITION_TEMPERATURE];
    return dictionary;
}

@end
