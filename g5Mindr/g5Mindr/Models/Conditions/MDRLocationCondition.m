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

@interface MDRLocationCondition ()

// PROTECTED
@property(nonatomic, strong, readwrite) NSString *address;

@end

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
        self.radius     = 500;
        self.address    = nil;
        self.location   = [MDRLocationManager sharedManager].currentLocation;
        [self updateDescription];
        [self refreshAddress];
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

- (void)updateDescription {
    if (self.isActive && self.address && ![self.address isEqualToString:@""])
        self.conditionDescription = [NSString stringWithFormat:@"At %@", self.address];
    else
        self.conditionDescription = @"LOCATION";
}

#pragma mark - Public

- (void)setAddress:(NSString *)address {
    if (address != nil) {
        _address = address;
        return;
    }
    _address = [NSString stringWithFormat:@"(%.3f\u00b0, %.3f\u00b0)",self.location.coordinate.latitude, self.location.coordinate.longitude];
}

#pragma mark - Public

- (void)setIsActive:(BOOL)isActive {
    super.isActive = isActive;
    [self updateDescription];
}

- (void)refreshAddress {
    __weak MDRLocationCondition *weakSelf = self;
    [[MDRLocationManager sharedManager] getAddressForLocation:self.location withSuccess:^(NSString *addressLine) {
        MDRLocationCondition *strongSelf = weakSelf;
        strongSelf.address = addressLine;
        [strongSelf updateDescription];
    } withFailure:^(NSError *error) {
        
    }];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    
    self.address = @"";
    if ([dictionary.allKeys containsObject:kMDRLocationAddress])
        self.address = [dictionary objectForKey:kMDRLocationAddress];
    
    self.location = nil;
    CLLocationDegrees latitude = ((NSNumber *)[dictionary objectForKey:kMDRLocationLatitude]).floatValue;
    CLLocationDegrees longitude = ((NSNumber *)[dictionary objectForKey:kMDRLocationLongitude]).floatValue;
    self.location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
   
    NSNumber *radiusNumber = [dictionary objectForKey:kMDRLocationRadius];
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
        [attributeDictionary setObject:self.address forKey:kMDRLocationAddress];
    }
    
    [attributeDictionary setObject:[NSNumber numberWithFloat:self.radius] forKey:kMDRLocationRadius];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
