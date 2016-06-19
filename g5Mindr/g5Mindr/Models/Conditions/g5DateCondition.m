//
//  g5DateCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DateCondition.h"

#define KEY_CONDITION_DATES @"KEY_CONDITION_DATES"

@interface g5DateCondition ()

@end

@implementation g5DateCondition

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
        self.type  = g5DateType;
        self.dates = [NSMutableArray arrayWithObjects:[NSDate date], nil];
    }
    return self;
}

#pragma mark - Over Ride

- (NSString *)conditionDescription {
    if (self.isActive) {
        NSDate *nextAvailableDate = [self.dates firstObject];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle =  NSDateFormatterLongStyle;
        NSString *dateString = [formatter stringFromDate:nextAvailableDate];
        
        return [NSString stringWithFormat:@"On %@", dateString];
    }
    return @"DATE";
}

#pragma mark - Validation

- (BOOL)validateWithContext:(MDRReminderContext *)context {
    NSDate* contextDate = context.currentDate;
    NSDate* dateToValidate = [self.dates firstObject];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsOfContextDate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                            fromDate:contextDate];
    NSDateComponents *componentsOfDateToValidate = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                               fromDate:dateToValidate];
    
    BOOL yearsMatch = (componentsOfContextDate.year == componentsOfDateToValidate.year);
    BOOL monthsMatch = (componentsOfContextDate.month == componentsOfDateToValidate.month);
    BOOL daysMatch = (componentsOfContextDate.day == componentsOfDateToValidate.day);
    
    if (daysMatch && monthsMatch && yearsMatch) {
        return YES;
    }
    return NO;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfDateEpochs = [dictionary objectForKey:KEY_CONDITION_DATES];
    
    NSMutableArray *tmpMutableArray = [[NSMutableArray alloc] init];
    for (NSNumber *epochTimeInSecondsNumber in arrayOfDateEpochs) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[epochTimeInSecondsNumber intValue]];
        [tmpMutableArray addObject:date];
    }
    self.dates = [NSMutableArray arrayWithArray:tmpMutableArray];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableArray *arrayOfDateEpochs = [[NSMutableArray alloc] init];
    for (NSDate *currentDate in self.dates) {
        NSTimeInterval epochTimeInSeconds = [currentDate timeIntervalSince1970];
        [arrayOfDateEpochs addObject:[NSNumber numberWithInt:epochTimeInSeconds]];
    }
    
    [dictionary setObject:arrayOfDateEpochs forKey:KEY_CONDITION_DATES];
    return dictionary;
}

@end
