//
//  g5LocationCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationCondition.h"
#import "MDRLocationManager.h"
#import <CoreLocation/CoreLocation.h>

#define KEY_CONDITION_LOCATION @"KEY_CONDITION_LOCATION"
#define KEY_CONDITION_RADIUS   @"KEY_CONDITION_RADIUS"
#define KEY_CONDITION_ADDRESS  @"KEY_CONDITION_ADDRESS"

static NSString *const kMDRLocationLongitude = @"longitude";
static NSString *const kMDRLocationLatitude = @"latitude";
static NSString *const kMDRLocationAddress = @"address";
static NSString *const kMDRLocationRadius = @"radius";

@implementation g5LocationCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary[kMDRConditionAttributes]];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type       = g5LocationType;
        self.location   = [MDRLocationManager sharedManager].currentLocation;
        self.radius     = 100;              // 100 Meters
        self.address    = @"";
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
        NSString *resultString = [NSString stringWithFormat:@"At %@", self.address];

        return resultString;
    }
    return @"LOCATION";
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {

    self.location = nil;
    if ([dictionary.allKeys containsObject:KEY_CONDITION_LOCATION]) {
        CLLocationDegrees latitude = ((NSNumber *)[dictionary objectForKey:kMDRLocationLatitude]).floatValue;
        CLLocationDegrees longitude = ((NSNumber *)[dictionary objectForKey:kMDRLocationLongitude]).floatValue;
        self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    }
    
    self.address = @"";
    if ([dictionary.allKeys containsObject:KEY_CONDITION_ADDRESS]) {
        self.address = [dictionary objectForKey:KEY_CONDITION_ADDRESS];
    }
    
    NSNumber *radiusNumber = [dictionary objectForKey:KEY_CONDITION_RADIUS];
    self.radius = [radiusNumber floatValue];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    if (self.location != nil) {
        [attributeDictionary setObject:[NSNumber numberWithFloat:self.location.coordinate.latitude] forKey:kMDRLocationLatitude];
        [attributeDictionary setObject:[NSNumber numberWithFloat:self.location.coordinate.longitude] forKey:kMDRLocationLongitude];
    }

    if (self.address != nil) {
        [attributeDictionary setObject:self.address forKey:KEY_CONDITION_ADDRESS];
    }
    
    [attributeDictionary setObject:[NSNumber numberWithFloat:self.radius] forKey:KEY_CONDITION_RADIUS];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    
    return superDictionary;
}

@end
