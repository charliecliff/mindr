//
//  g5LocationCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationCondition.h"
#import <CoreLocation/CoreLocation.h>

@implementation g5LocationCondition

#pragma mark - Init

- (instancetype)init {
    assert(false);
}

- (instancetype)initWithLocationDatasource:(id<g5LocationDatasource>)datasource {
    self = [super init];
    if (self != nil) {
        self.datasource = datasource;
        self.uid        = [NSNumber numberWithInt:g5ConditionIDLocation];
        self.type       = g5LocationType;
        self.location   = nil;
        self.radius     = 0;
    }
    return self;
}

#pragma mark - Over Ride

- (BOOL)isValid {
    CLLocationDistance distanceToCurrentLocation = [[self.datasource currentLocation] distanceFromLocation:self.location];
    return !(distanceToCurrentLocation > self.radius);
}

- (NSString *)detailsText {
    return @"_details_";
}

- (NSString *)placeholderText {
    return @"LOCATION";
}

@end
