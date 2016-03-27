//
//  g5TimeCondition.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimeCondition.h"

#define NOON 43200

@interface g5TimeCondition ()

@property(nonatomic, readwrite) NSTimeInterval timeOfDayInSeconds;

@end

@implementation g5TimeCondition

#pragma mark - Init

- (instancetype)initWithEventDatasource:(id<g5EventDatasource>)datasource {
    self = [super init];
    if (self != nil) {
        self.datasource         = datasource;
        self.uid                = [NSNumber numberWithInt:g5ConditionIDTime];
        self.type               = g5TimeType;
        self.timeOfDayInSeconds = NOON;
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
    return @"TIME";
}

@end
