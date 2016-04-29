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

@interface g5TimeCondition ()

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
        self.uid                = [NSNumber numberWithInt:g5ConditionIDTime];
        self.type               = g5TimeType;
        self.timeOfDayInSeconds = NOON;
    }
    return self;
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    self.timeOfDayInSeconds = minute * 60 + hour * 60 * 60;
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

#pragma mark - Over Ride

- (BOOL)isValidDate:(NSDate *)date {

    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
    NSDate *const normalizedDate = [calendar dateFromComponents:components];
    
    NSDate *dateWithTimeOfDayAdded = [normalizedDate dateByAddingTimeInterval:self.timeOfDayInSeconds];
    
    return NO;
}

- (NSString *)detailsText {
    return @"_details_";
}

- (NSString *)placeholderText {
    return @"TIME";
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSNumber *timeOfDayAsNumber = [dictionary objectForKey:KEY_CONDITION_TIME_OF_DAY_IN_SECONDS];
    self.timeOfDayInSeconds = [timeOfDayAsNumber intValue];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSNumber *timeOfDayAsNumber = [NSNumber numberWithInt:self.timeOfDayInSeconds];
    [dictionary setObject:timeOfDayAsNumber forKey:KEY_CONDITION_TIME_OF_DAY_IN_SECONDS];
    
    return dictionary;
}

@end
