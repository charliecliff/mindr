//
//  g5Condition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

#define KEY_CONDITION_TYPE  @"KEY_CONDITION_TYPE"
#define KEY_CONDITION_ID    @"KEY_CONDITION_ID"
#define KEY_IS_ACTIVE       @"KEY_IS_ACTIVE"
#define KEY_IS_LOCKED       @"KEY_IS_LOCKED"

NSString *const g5NoType            = @"none";
NSString *const g5DateType          = @"date";
NSString *const g5TimeType          = @"time";
NSString *const g5DayOfTheWeekType  = @"day_of_the_week";
NSString *const g5WeatherType       = @"weather";
NSString *const g5TemperatureType   = @"temp";
NSString *const g5LocationType      = @"location";


static NSString *const kMDRConditionUID      = @"uid";
static NSString *const kMDRConditionTitle    = @"type";
static NSString *const kMDRConditionIsLocked = @"is_locked";
static NSString *const kMDRConditionIsActive = @"is_active";

@implementation MDRCondition


#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": kMDRConditionUID,
             @"type": kMDRConditionTitle,
             @"isActive": kMDRConditionIsActive,
             @"isLocked": kMDRConditionIsLocked};
}

//#pragma mark - Init
//
//- (instancetype)init {
//    self = [super init];
//    if (self != nil) {
//        self.type = g5NoType;
//        self.isActive = NO;
//        self.isLocked = NO;
//        [self generateUID];
//    }
//    return self;
//}
//
//- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
//    self = [self init];
//    if (self != nil) {
//        self.uid  = [dictionary objectForKey:KEY_CONDITION_ID];
//        self.type = [dictionary objectForKey:KEY_CONDITION_TYPE];
//        self.isActive = [[dictionary objectForKey:KEY_IS_ACTIVE] boolValue];
//        self.isLocked = [[dictionary objectForKey:KEY_IS_LOCKED] boolValue];
//    }
//    return self;
//}

#pragma mark - Setup

- (void)generateUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    self.uid = (__bridge_transfer NSString *)uuidStringRef;
}

#pragma mark - Over Ride

- (NSString *)detailsText {
    assert(false);
}

- (NSString *)placeholderText {
    assert(false);
}

- (NSString *)conditionDescription {
    assert(false);
}

- (NSString *)conditionIconName {
    assert(false);
}

@end
