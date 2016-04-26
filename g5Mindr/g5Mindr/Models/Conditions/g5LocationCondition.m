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
        self.uid        = [NSNumber numberWithInt:g5ConditionIDLocation];
        self.type       = g5LocationType;
        self.location   = nil;
        self.radius     = 0;
    }
    return self;
}

#pragma mark - Over Ride

//- (BOOL)isValid {
//    CLLocationDistance distanceToCurrentLocation = [[self.datasource currentLocation] distanceFromLocation:self.location];
//    return !(distanceToCurrentLocation > self.radius);
//}

- (NSString *)detailsText {
    return @"_details_";
}

- (NSString *)placeholderText {
    return @"LOCATION";
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
