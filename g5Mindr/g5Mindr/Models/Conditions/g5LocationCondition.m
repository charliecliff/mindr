//
//  g5LocationCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationCondition.h"

//static NSString *const kMDRLocationLongitude = @"longitude";
//static NSString *const kMDRLocationLatitude = @"latitude";

static NSString *const kMDRLocationAddress  = @"address";
static NSString *const kMDRLocationLocation = @"location";
static NSString *const kMDRLocationRadius   = @"radius";

@implementation g5LocationCondition

#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *superDictionary = [super JSONKeyPathsByPropertyKey];
    return [superDictionary mtl_dictionaryByAddingEntriesFromDictionary:@{@"radius":kMDRLocationRadius,
                                                                          @"address":kMDRLocationAddress}];
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type       = g5LocationType;
//        self.location   = [MDRLocationManager sharedManager].currentLocation;
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

@end
