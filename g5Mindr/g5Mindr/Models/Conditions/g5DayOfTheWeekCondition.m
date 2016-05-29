//
//  g5DayOfTheWeekCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DayOfTheWeekCondition.h"
#import "g5ConfigAndMacros.h"

static NSString *const G5DayOfTheWeekDateFormatter = @"EEEE";
static NSString *const G5DaysOfTheWeek = @"days_of_the_week";

@interface g5DayOfTheWeekCondition ()

@property(nonatomic, strong, readwrite) NSString *dayOfTheWeekString;
@property(nonatomic, strong, readwrite) NSMutableSet *daysOfTheWeek;

@end

@implementation g5DayOfTheWeekCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary];
        [self generateDescriptionStringFromDaysOfTheWeek];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = g5DayOfTheWeekType;
        self.daysOfTheWeek = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - Setters

- (void)setDayOfTheWeek:(NSInteger)weekday {
    [self.daysOfTheWeek addObject:[NSNumber numberWithUnsignedInteger:weekday]];
    [self generateDescriptionStringFromDaysOfTheWeek];
}

- (void)removeDayOfTheWeek:(NSInteger)weekday {
    [self.daysOfTheWeek removeObject:[NSNumber numberWithUnsignedInteger:weekday]];
    [self generateDescriptionStringFromDaysOfTheWeek];
}

- (BOOL)containsDayOfTheWeek:(NSInteger)weekday {
    return [self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:weekday]];
}

- (void)generateDescriptionStringFromDaysOfTheWeek {
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar   = gregorianCalendar;
    formatter.dateFormat = G5DayOfTheWeekDateFormatter;
    
    self.dayOfTheWeekString = @"";
    for (NSNumber *currentDayOfTheWeekNumber in self.daysOfTheWeek) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.day = [currentDayOfTheWeekNumber unsignedIntegerValue];
        NSDate *currentDate = [gregorianCalendar dateFromComponents:dateComponents];

        NSString *currentDayOfTheWeekString = [formatter stringFromDate:currentDate];
    }
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    return CONDITION_TITLE_FOR_DAY_OF_THE_WEEK;
}

#pragma mark - Validation

- (BOOL)isValidDate:(NSDate *)date {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitWeekday fromDate:date];
    NSUInteger weekday = components.weekday;
    return [self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:weekday] ];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSMutableSet *setOfDaysOfTheWeek = [dictionary objectForKey:G5DaysOfTheWeek];
    self.daysOfTheWeek = setOfDaysOfTheWeek;
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    [dictionary setObject:self.daysOfTheWeek forKey:G5DaysOfTheWeek];
    return dictionary;
}

@end
