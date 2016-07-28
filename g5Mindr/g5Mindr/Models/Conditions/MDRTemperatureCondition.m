//
//  g5TemperatureCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRTemperatureCondition.h"

static NSString *const kMDRConditionTemperature = @"temperature";

@implementation MDRTemperatureCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary[kMDRConditionAttributes]];
        [self updateDescription];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type        = g5TemperatureType;
        self.temperature = [NSNumber numberWithFloat:67.0];
        self.temperatureComparisonType = NSOrderedSame;
        [self updateDescription];
    }
    return self;
}

- (void)setTemperatureunit:(g5TemperatureUnit)temperatureunit {
    _temperatureunit = temperatureunit;
    [self updateDescription];
}

- (void)setTemperature:(NSNumber *)temperature {
    _temperature = temperature;
    [self updateDescription];
}

- (void)setTemperatureComparisonType:(NSComparisonResult)temperatureComparisonType {
    _temperatureComparisonType = temperatureComparisonType;
    [self updateDescription];
}

- (void)updateDescription {
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
        
        self.conditionDescription = resultString;
    }
    else
        self.conditionDescription =  @"TEMPERATURE";
    
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.temperature = [dictionary objectForKey:kMDRConditionTemperature];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:self.temperature forKey:kMDRConditionTemperature];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
