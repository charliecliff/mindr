//
//  g5TimeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimeCondition.h"

static NSString *const MDRTimeComponentHour     = @"hour";
static NSString *const MDRTimeComponentMinute   = @"minute";
static NSString *const MDRTimeComponentMeridian = @"meridian";

@interface g5TimeCondition ()

@property(nonatomic, readwrite) NSInteger dateComponentForHour;
@property(nonatomic, readwrite) NSInteger dateComponentForMinute;

@property(nonatomic, readwrite) NSTimeInterval timeOfDayInSeconds;

@end

@implementation g5TimeCondition

#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *superDictionary = [super JSONKeyPathsByPropertyKey];
    return [superDictionary mtl_dictionaryByAddingEntriesFromDictionary:@{@"hour":MDRTimeComponentHour,
                                                                          @"minute":MDRTimeComponentMinute,
                                                                          @"meridian":MDRTimeComponentMeridian}];
}

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = g5TimeType;
        self.hour = 12;
        self.minute = 0;
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

@end
