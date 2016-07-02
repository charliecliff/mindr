//
//  g5DateCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DateCondition.h"

static NSString *const kMDRDates = @"dates";

@implementation g5DateCondition

#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSDictionary *superDictionary = [super JSONKeyPathsByPropertyKey];
    return [superDictionary mtl_dictionaryByAddingEntriesFromDictionary:@{@"dates":kMDRDates}];
}

+ (NSValueTransformer *)datesJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^(NSArray *dateStrings, BOOL *success, NSError **error){
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (NSString *currentDateString in dateStrings) {
            NSDate *date = [self.dateFormatter dateFromString:currentDateString];
            [tmp addObject:date];
        }
        return tmp;
    } reverseBlock:^(NSArray *dates, BOOL *success, NSError **error) {
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        for (NSDate *currentDate in dates) {
            NSString *string = [self.dateFormatter stringFromDate:currentDate];
            [tmp addObject:string];
        }
        return tmp;
    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    return dateFormatter;
}

#pragma mark - Init

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

@end
