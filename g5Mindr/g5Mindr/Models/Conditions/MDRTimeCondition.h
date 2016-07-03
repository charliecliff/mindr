//
//  g5TimeCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

typedef enum {
    MDRTimeAM = 0,
    MDRTimePM,
} MDRTimeMeridian;

@interface MDRTimeCondition : MDRCondition

@property(nonatomic) NSInteger hour;
@property(nonatomic) NSInteger minute;
@property(nonatomic) MDRTimeMeridian meridian;

@property(nonatomic, readonly) NSInteger dateComponentForHour;
@property(nonatomic, readonly) NSInteger dateComponentForMinute;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
