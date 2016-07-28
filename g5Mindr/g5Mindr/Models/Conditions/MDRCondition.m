//
//  g5Condition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

NSString *const g5NoType            = @"none";
NSString *const g5DateType          = @"date";
NSString *const g5TimeType          = @"time";
NSString *const g5DayOfTheWeekType  = @"day_of_week";
NSString *const g5WeatherType       = @"weather";
NSString *const g5TemperatureType   = @"temperature";
NSString *const g5LocationType      = @"location";

NSString *const kMDRConditionType = @"type";
NSString *const kMDRConditionAttributes = @"attributes";

static NSString *const kMDRConditionID      = @"id";
static NSString *const kMDRConditionIsLocked = @"is_locked";
static NSString *const kMDRConditionIsActive = @"is_active";

@implementation MDRCondition

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = g5NoType;
        self.isActive = NO;
        self.isLocked = NO;
        [self generateUID];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self != nil) {
        self.uid  = [dictionary objectForKey:kMDRConditionID];
        self.type = [dictionary objectForKey:kMDRConditionType];
        self.isActive = [[dictionary objectForKey:kMDRConditionIsActive] boolValue];
        self.isLocked = [[dictionary objectForKey:kMDRConditionIsLocked] boolValue];
    }
    return self;
}

#pragma mark - Setup

- (void)generateUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    self.uid = (__bridge_transfer NSString *)uuidStringRef;
}

- (void)setIsActive:(BOOL)isActive {
    _isActive = isActive;
    [self updateDescription];
}

#pragma mark - Over Ride

- (NSString *)detailsText {
    assert(false);
}

- (NSString *)placeholderText {
    assert(false);
}

- (NSString *)conditionIconName {
    assert(false);
}

- (void)updateDescription {
    NSAssert(false, @"BRO! You need to implement this method in the subclass");
}

#pragma mark - Persistence

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    [dictionary setObject:self.uid forKey:kMDRConditionID];
    [dictionary setObject:self.type forKey:kMDRConditionType];
    [dictionary setObject:[NSNumber numberWithBool:self.isActive] forKey:kMDRConditionIsActive];
    [dictionary setObject:[NSNumber numberWithBool:self.isLocked] forKey:kMDRConditionIsLocked];

    return dictionary;
}

@end
