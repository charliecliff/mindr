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

@interface MDRTime : NSObject

@property(nonatomic) NSInteger hour;
@property(nonatomic) NSInteger minute;
@property(nonatomic) MDRTimeMeridian meridian;
@property(nonatomic, strong) NSString *timeZoneString;

- (NSString *)description;

@end

@interface MDRTimeCondition : MDRCondition

@property(nonatomic, strong, readonly) NSMutableArray *times;

- (void)addTime:(MDRTime *)time;
- (void)removeTime:(MDRTime *)time;

@end
