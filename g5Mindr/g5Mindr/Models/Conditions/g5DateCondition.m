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

- (instancetype)initWithDates:(NSArray *)dates {
    self = [super init];
    if (self != nil) {
        self.uid   = [NSNumber numberWithInt:g5ConditionIDDate];
        self.type  = g5DateType;
        self.dates = dates;
    }
    return self;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfDateEpochs = [dictionary objectForKey:KEY_CONDITION_DATES];
    
    NSMutableArray *tmpMutableArray = [[NSMutableArray alloc] init];
    for (NSNumber *epochTimeInSecondsNumber in arrayOfDateEpochs) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[epochTimeInSecondsNumber intValue]];
        [tmpMutableArray addObject:date];
    }
    self.dates = [NSArray arrayWithArray:tmpMutableArray];
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
