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
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = g5DayOfTheWeekType;
        self.daysOfTheWeek = [[NSMutableSet alloc] initWithObjects:[NSNumber numberWithDouble:1], nil];
    }
    return self;
}

#pragma mark - Setters

- (void)setDayOfTheWeek:(NSInteger)weekday {
    [self.daysOfTheWeek addObject:[NSNumber numberWithUnsignedInteger:weekday]];
}

- (void)removeDayOfTheWeek:(NSInteger)weekday {
    [self.daysOfTheWeek removeObject:[NSNumber numberWithUnsignedInteger:weekday]];
}

- (BOOL)containsDayOfTheWeek:(NSInteger)weekday {
    NSNumber *dayOfTheWeekNumber = [NSNumber numberWithUnsignedInteger:weekday];
    BOOL output = [self.daysOfTheWeek containsObject:dayOfTheWeekNumber];
    return output;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"EEEE"];
        
        NSString *resultString = @"On a";
        for (NSNumber *dayOfTheWeekNumber in self.daysOfTheWeek) {
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
            dateComponents.weekday = [dayOfTheWeekNumber integerValue];
            
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *timeOfDayDate = [gregorianCalendar dateFromComponents:dateComponents];
            
            NSString *dateString = [formatter stringFromDate:timeOfDayDate];
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, dateString];
        }
        return resultString;
    }
    return CONDITION_TITLE_FOR_DAY_OF_THE_WEEK;
}

#pragma mark - Validation

- (BOOL)validateWithContext:(MDRReminderContext *)context {
    NSDate* contextDate = context.currentDate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsOfContextDate = [calendar components:NSCalendarUnitWeekday
                                                            fromDate:contextDate];
    
    NSUInteger weekday = componentsOfContextDate.weekday;
    return [self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:weekday] ];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfDaysOfTheWeek = [dictionary objectForKey:G5DaysOfTheWeek];
    self.daysOfTheWeek = [NSMutableSet setWithArray:arrayOfDaysOfTheWeek];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    [dictionary setObject:self.daysOfTheWeek.allObjects forKey:G5DaysOfTheWeek];
    return dictionary;
}

@end
