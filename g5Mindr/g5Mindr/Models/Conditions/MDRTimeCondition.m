//
//  g5TimeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRTimeCondition.h"

#define NOON 43200

static NSString *const MDRTimeComponentHour     = @"hour";
static NSString *const MDRTimeComponentMinute   = @"minute";
static NSString *const MDRTimeComponentMeridian = @"meridian";

@interface MDRTimeCondition ()

@property(nonatomic, readwrite) NSInteger dateComponentForHour;
@property(nonatomic, readwrite) NSInteger dateComponentForMinute;

@property(nonatomic, readwrite) NSTimeInterval timeOfDayInSeconds;

@end

@implementation MDRTimeCondition

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
        self.type = g5TimeType;
        self.hour = 12;
        self.minute = 0;

        self.timeOfDayInSeconds = NOON; // TODO: Pull this
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.hour = self.hour;
        dateComponents.minute = self.minute;
        
        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *timeOfDayDate = [gregorianCalendar dateFromComponents:dateComponents];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.timeStyle =  NSDateFormatterShortStyle;
        
        NSString *dateString = [formatter stringFromDate:timeOfDayDate];
        
        return [NSString stringWithFormat:@"At %@", dateString];
    }
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

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.hour = [[dictionary objectForKey:MDRTimeComponentHour] integerValue];
    self.minute = [[dictionary objectForKey:MDRTimeComponentMinute] integerValue];
    self.meridian = [[dictionary objectForKey:MDRTimeComponentMeridian] intValue];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];

    [attributeDictionary setObject:[NSNumber numberWithInteger:self.hour] forKey:MDRTimeComponentHour];
    [attributeDictionary setObject:[NSNumber numberWithInteger:self.minute] forKey:MDRTimeComponentMinute];
    [attributeDictionary setObject:[NSNumber numberWithInt:self.meridian] forKey:MDRTimeComponentMeridian];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
