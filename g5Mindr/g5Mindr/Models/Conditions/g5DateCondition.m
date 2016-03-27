//
//  g5DateCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DateCondition.h"

@interface g5DateCondition ()

@property(nonatomic, readwrite) NSDate *date;

@end

@implementation g5DateCondition

#pragma mark - Init

- (instancetype)initWithEventDatasource:(id<g5EventDatasource>)datasource {
    self = [super init];
    if (self != nil) {
        self.datasource = datasource;
        self.uid        = [NSNumber numberWithInt:g5ConditionIDDate];
        self.type       = g5DateType;
        self.date       = [NSDate date];
    }
    return self;
}

#pragma mark - Over Ride

- (BOOL)isValid {
    return NO;
}

- (NSString *)detailsText {
    return @"_details_";
}

- (NSString *)placeholderText {
    return @"DATE";
}

@end
