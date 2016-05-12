//
//  g5LocationCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationCondition.h"
#import <CoreLocation/CoreLocation.h>

#define KEY_CONDITION_LOCATION @"KEY_CONDITION_LOCATION"
#define KEY_CONDITION_RADIUS   @"KEY_CONDITION_RADIUS"

@implementation g5LocationCondition

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
        self.type       = g5LocationType;
        self.location   = nil;
        self.radius     = 100;              // 100 Meters
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    return @"LOCATION";
}

#pragma mark - Validation

- (BOOL)isValidLocation:(CLLocation *)location {
    CLLocationDistance distanceToCurrentLocation = [location distanceFromLocation:self.location];
    return !(distanceToCurrentLocation > self.radius);
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    
    self.location = nil;
    if ([dictionary.allKeys containsObject:KEY_CONDITION_LOCATION]) {
        self.location = [dictionary objectForKey:KEY_CONDITION_LOCATION];
    }
    
    NSNumber *radiusNumber = [dictionary objectForKey:KEY_CONDITION_RADIUS];
    self.radius = [radiusNumber floatValue];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    if (self.location != nil) {
        [dictionary setObject:self.location forKey:KEY_CONDITION_LOCATION];
    }
    
    [dictionary setObject:[NSNumber numberWithFloat:self.radius] forKey:KEY_CONDITION_RADIUS];
    return dictionary;
}

@end
