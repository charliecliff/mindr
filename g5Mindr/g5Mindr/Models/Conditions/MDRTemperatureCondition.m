//
//  g5TemperatureCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRTemperatureCondition.h"

static NSString *const kMDRConditionTemperature = @"temperature";
static NSString *const kMDRTemperatureDegrees   = @"degrees";
static NSString *const kMDRTemperatureOperator  = @"operator";
static NSString *const kMDRTemperatureUnit      = @"unit";

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
    
    NSString *string;
    string = [dictionary objectForKey:kMDRTemperatureOperator];
    if ([string isEqualToString:@"at"])
        self.temperatureComparisonType = NSOrderedSame;
    else if ([string isEqualToString:@"below"])
        self.temperatureComparisonType = NSOrderedAscending;
    else if ([string isEqualToString:@"above"])
        self.temperatureComparisonType = NSOrderedDescending;
    
    string = [dictionary objectForKey:kMDRTemperatureUnit];
    if ([string isEqualToString:@"F"])
        self.temperatureunit = g5TemperatureFahrenheit;
    else if ([string isEqualToString:@"C"])
        self.temperatureunit = g5TemperatureCelsius;
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:self.temperature forKey:kMDRTemperatureDegrees];
    switch (self.temperatureComparisonType) {
        case NSOrderedSame:
            [attributeDictionary setObject:@"at" forKey:kMDRTemperatureOperator];
            break;
        case NSOrderedAscending:
            [attributeDictionary setObject:@"below" forKey:kMDRTemperatureOperator];
            break;
        case NSOrderedDescending:
            [attributeDictionary setObject:@"above" forKey:kMDRTemperatureOperator];
            break;
        default:
            break;
    }
    switch (self.temperatureunit) {
        case g5TemperatureFahrenheit:
            [attributeDictionary setObject:@"F" forKey:kMDRTemperatureUnit];
            break;
        case g5TemperatureCelsius:
            [attributeDictionary setObject:@"C" forKey:kMDRTemperatureUnit];
            break;
        default:
            break;
    }
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
