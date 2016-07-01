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
