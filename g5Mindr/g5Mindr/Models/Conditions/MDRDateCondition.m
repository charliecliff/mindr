//
//  g5DateCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRDateCondition.h"

static NSString *const kMDRConditionDates = @"days";
static NSString *const kMDRConditionDateFormatter = @"dd/MM/YYYY";

@interface MDRDateCondition ()

@end

@implementation MDRDateCondition

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
        self.type  = g5DateType;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitWeekOfMonth| NSCalendarUnitWeekday fromDate:[NSDate date]];
        NSDate *newDate = [[NSCalendar currentCalendar] dateFromComponents:components];

        self.dates = [NSMutableArray arrayWithObjects:newDate, nil];
        [self updateDescription];
    }
    return self;
}

- (void)updateDescription {
    if (self.isActive) {
        NSDate *nextAvailableDate = [self.dates firstObject];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle =  NSDateFormatterLongStyle;
        NSString *dateString = [formatter stringFromDate:nextAvailableDate];
        
        self.conditionDescription = [NSString stringWithFormat:@"On %@", dateString];
    }
    else
        self.conditionDescription = @"DATE";
}

- (void)setDates:(NSMutableArray *)dates {
    _dates = dates;
    [self updateDescription];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfDateEpochs = [dictionary objectForKey:kMDRConditionDates];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kMDRConditionDateFormatter;

    NSMutableArray *tmpMutableArray = [[NSMutableArray alloc] init];
    for (NSString *dateString in arrayOfDateEpochs) {
        NSDate *date = [dateFormatter dateFromString:dateString];
        [tmpMutableArray addObject:date];
    }
    self.dates = [NSMutableArray arrayWithArray:tmpMutableArray];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = kMDRConditionDateFormatter;
    
    NSMutableArray *arrayOfDateEpochs = [[NSMutableArray alloc] init];
    for (NSDate *currentDate in self.dates) {
        NSString *dateString = [[dateFormatter stringFromDate:currentDate] capitalizedString];
        [arrayOfDateEpochs addObject:dateString];
    }
    
    [attributeDictionary setObject:arrayOfDateEpochs forKey:kMDRConditionDates];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
