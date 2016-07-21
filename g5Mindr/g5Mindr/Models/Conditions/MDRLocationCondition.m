//
//  g5LocationCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRLocationCondition.h"
#import "MDRLocationManager.h"
#import <CoreLocation/CoreLocation.h>

static NSString *const kMDRLocationLongitude = @"longitude";
static NSString *const kMDRLocationLatitude = @"latitude";
static NSString *const kMDRLocationAddress = @"address";
static NSString *const kMDRLocationRadius = @"radius";

@implementation MDRLocationCondition

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
        self.radius     = 500;              // 100 Meters
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
    CLLocationDegrees latitude = ((NSNumber *)[dictionary objectForKey:kMDRLocationLatitude]).floatValue;
    CLLocationDegrees longitude = ((NSNumber *)[dictionary objectForKey:kMDRLocationLongitude]).floatValue;
    self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
   
    NSNumber *radiusNumber = [dictionary objectForKey:kMDRLocationRadius];
    self.radius = [radiusNumber floatValue];

    self.address = @"";
    if ([dictionary.allKeys containsObject:kMDRLocationAddress]) {
        self.address = [dictionary objectForKey:kMDRLocationAddress];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    if (self.location != nil) {
        [attributeDictionary setObject:[NSNumber numberWithFloat:self.location.coordinate.latitude] forKey:kMDRLocationLatitude];
        [attributeDictionary setObject:[NSNumber numberWithFloat:self.location.coordinate.longitude] forKey:kMDRLocationLongitude];
    }

    if (self.address != nil) {
        [attributeDictionary setObject:self.address forKey:kMDRLocationAddress];
    }
    
    [attributeDictionary setObject:[NSNumber numberWithFloat:self.radius] forKey:kMDRLocationRadius];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
