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

@implementation MDRTime

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"hour": MDRTimeComponentHour,
             @"minute": MDRTimeComponentMinute,
             @"meridian": MDRTimeComponentMeridian
             };
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.hour     = 12;
        self.minute   = 0;
        self.meridian = MDRTimePM;
    }
    return self;
}

- (NSString *)description {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = self.hour;
    dateComponents.minute = self.minute;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *timeOfDayDate = [gregorianCalendar dateFromComponents:dateComponents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle =  NSDateFormatterShortStyle;
    NSString *dateString = [formatter stringFromDate:timeOfDayDate];
        
    return [NSString stringWithFormat:@"%@", dateString];
}

@end

@interface MDRTimeCondition ()

@property(nonatomic, strong, readwrite) NSMutableArray *times;

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
        self.times = [[NSMutableArray alloc] initWithObjects:[[MDRTime alloc] init], nil];
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
//        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
//        dateComponents.hour = self.hour;
//        dateComponents.minute = self.minute;
//        
//        NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//        NSDate *timeOfDayDate = [gregorianCalendar dateFromComponents:dateComponents];
//        
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.timeStyle =  NSDateFormatterShortStyle;
//        
//        NSString *dateString = [formatter stringFromDate:timeOfDayDate];
//        
//        return [NSString stringWithFormat:@"At %@", dateString];
    }
    return @"TIME";
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];

    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
