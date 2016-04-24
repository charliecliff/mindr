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
