//
//  g5TimeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimeCondition.h"

#define NOON 43200

#define KEY_CONDITION_TIME_OF_DAY_IN_SECONDS @"KEY_CONDITION_TIME_OF_DAY_IN_SECONDS"

static NSString *const MDRTimeComponentHour     = @"hour";
static NSString *const MDRTimeComponentMinute   = @"minute";
static NSString *const MDRTimeComponentMeridian = @"meridian";

@interface g5TimeCondition ()

@property(nonatomic, readwrite) NSInteger dateComponentForHour;
@property(nonatomic, readwrite) NSInteger dateComponentForMinute;

@property(nonatomic, readwrite) NSTimeInterval timeOfDayInSeconds;

@end

@implementation g5TimeCondition

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
        self.type               = g5TimeType;
        self.timeOfDayInSeconds = NOON;
        
        self.hour   = 12;
        self.minute = 0;
        
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    return @"TIME";
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    self.timeOfDayInSeconds = minute * 60 + hour * 60 * 60;
}

#pragma mark - Validation

- (BOOL)isValidDate:(NSDate *)date {
    return self.isActive && NO;

//    NSCalendar *const calendar = NSCalendar.currentCalendar;
//    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
//    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
//    NSDate *const normalizedDate = [calendar dateFromComponents:components];
//    
//    NSDate *dateWithTimeOfDayAdded = [normalizedDate dateByAddingTimeInterval:self.timeOfDayInSeconds];
//    
//    
//    
}

#pragma mark - Helpers

- (NSDate *)todayAtMidnight {
    NSDate *const date = NSDate.date;
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
    NSDate *const normalizedDate = [calendar dateFromComponents:components];
    return normalizedDate;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.hour = [[dictionary objectForKey:MDRTimeComponentHour] integerValue];
    self.minute = [[dictionary objectForKey:MDRTimeComponentMinute] integerValue];
    self.meridian = [[dictionary objectForKey:MDRTimeComponentMeridian] intValue];
    
    NSNumber *timeOfDayAsNumber = [dictionary objectForKey:KEY_CONDITION_TIME_OF_DAY_IN_SECONDS];
    self.timeOfDayInSeconds = [timeOfDayAsNumber intValue];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];

    [dictionary setObject:[NSNumber numberWithInteger:self.hour] forKey:MDRTimeComponentHour];
    [dictionary setObject:[NSNumber numberWithInteger:self.minute] forKey:MDRTimeComponentMinute];
    [dictionary setObject:[NSNumber numberWithInt:self.meridian] forKey:MDRTimeComponentMeridian];
    
    NSNumber *timeOfDayAsNumber = [NSNumber numberWithInt:self.timeOfDayInSeconds];
    [dictionary setObject:timeOfDayAsNumber forKey:KEY_CONDITION_TIME_OF_DAY_IN_SECONDS];
    
    return dictionary;
}

@end
