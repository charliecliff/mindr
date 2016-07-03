//
//  g5DateCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRDateCondition.h"

static NSString *const kMDRConditionDates = @"dates";

@interface MDRDateCondition ()

@end

@implementation MDRDateCondition

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

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfDateEpochs = [dictionary objectForKey:kMDRConditionDates];
    
    NSMutableArray *tmpMutableArray = [[NSMutableArray alloc] init];
    for (NSNumber *epochTimeInSecondsNumber in arrayOfDateEpochs) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[epochTimeInSecondsNumber intValue]];
        [tmpMutableArray addObject:date];
    }
    self.dates = [NSMutableArray arrayWithArray:tmpMutableArray];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *arrayOfDateEpochs = [[NSMutableArray alloc] init];
    for (NSDate *currentDate in self.dates) {
        NSTimeInterval epochTimeInSeconds = [currentDate timeIntervalSince1970];
        [arrayOfDateEpochs addObject:[NSNumber numberWithInt:epochTimeInSeconds]];
    }
    
    [attributeDictionary setObject:arrayOfDateEpochs forKey:kMDRConditionDates];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
