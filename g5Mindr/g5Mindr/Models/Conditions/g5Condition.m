//
//  g5Condition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"

#define KEY_CONDITION_TYPE @"KEY_CONDITION_TYPE"
#define KEY_CONDITION_ID   @"KEY_CONDITION_ID"

NSString *const g5DateType        = @"date";
NSString *const g5TimeType        = @"time";
NSString *const g5WeatherType     = @"weather";
NSString *const g5TemperatureType = @"temp";
NSString *const g5LocationType    = @"location";

@implementation g5Condition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self != nil) {
        self.uid  = [dictionary objectForKey:KEY_CONDITION_ID];
        self.type = [dictionary objectForKey:KEY_CONDITION_TYPE];
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)detailsText {
    assert(false);
}

- (NSString *)placeholderText {
    assert(false);
}

#pragma mark - Persistence

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.uid forKey:KEY_CONDITION_ID];
    [dictionary setObject:self.type forKey:KEY_CONDITION_TYPE];
    return dictionary;
}

@end
