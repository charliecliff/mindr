//
//  g5DayOfTheWeekCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRDayOfTheWeekCondition.h"
#import "g5ConfigAndMacros.h"

static NSString *const G5DayOfTheWeekDateFormatter = @"EEEE";
static NSString *const MDRDaysOfTheWeek = @"days_of_the_week";

@interface MDRDayOfTheWeekCondition ()

@property(nonatomic, strong, readwrite) NSString *dayOfTheWeekString;
@property(nonatomic, strong, readwrite) NSMutableSet *daysOfTheWeek;

@end

@implementation MDRDayOfTheWeekCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary[kMDRConditionAttributes]];
        [self updateDescription];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = g5DayOfTheWeekType;
        self.daysOfTheWeek = [[NSMutableSet alloc] initWithObjects:[NSNumber numberWithDouble:0], nil];
        [self updateDescription];
    }
    return self;
}

#pragma mark - Setters

- (void)setDaysOfTheWeek:(NSMutableSet *)daysOfTheWeek {
    _daysOfTheWeek = daysOfTheWeek;
    [self updateDescription];
}

- (void)setDayOfTheWeek:(NSInteger)weekday {
    [self.daysOfTheWeek addObject:[NSNumber numberWithInteger:weekday]];
    [self updateDescription];
}

- (void)removeDayOfTheWeek:(NSInteger)weekday {
    [self.daysOfTheWeek removeObject:[NSNumber numberWithInteger:weekday]];
    [self updateDescription];
}

- (BOOL)containsDayOfTheWeek:(NSInteger)weekday {
    NSNumber *dayOfTheWeekNumber = [NSNumber numberWithInteger:weekday];
    BOOL output = [self.daysOfTheWeek containsObject:dayOfTheWeekNumber];
    return output;
}

#pragma mark - Over Ride

- (void)updateDescription {
    if (self.isActive) {
        NSString *resultString = @"On a";
        for (NSNumber *currentDayOfTheWeek in self.daysOfTheWeek) {
            NSString *dateString = [self stringForWeekday:[currentDayOfTheWeek integerValue]];
            resultString = [NSString stringWithFormat:@"%@ %@", resultString, dateString];
        }
        self.conditionDescription = resultString;
    }
    else
        self.conditionDescription = CONDITION_TITLE_FOR_DAY_OF_THE_WEEK;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.daysOfTheWeek = [[NSMutableSet alloc] init];
    
    if ([(NSNumber *)[dictionary objectForKey:@"monday"] boolValue]) {
        [self setDayOfTheWeek:0];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"tuesday"] boolValue]) {
        [self setDayOfTheWeek:1];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"wednesday"] boolValue]) {
        [self setDayOfTheWeek:2];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"thursday"] boolValue]) {
        [self setDayOfTheWeek:3];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"friday"] boolValue]) {
        [self setDayOfTheWeek:4];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"saturday"] boolValue]) {
        [self setDayOfTheWeek:5];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"sunday"] boolValue]) {
        [self setDayOfTheWeek:6];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:0]])] forKey:@"monday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:1]])] forKey:@"tuesday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:2]])] forKey:@"wednesday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:3]])] forKey:@"thursday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:4]])] forKey:@"friday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:5]])] forKey:@"saturday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:6]])] forKey:@"sunday"];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

#pragma mark - Helpers

- (NSString *)stringForWeekday:(NSInteger)dayOfTheWeekNumber {
    return [DAYS_OF_THE_WEEK_ARRAY objectAtIndex:dayOfTheWeekNumber];
}

@end
