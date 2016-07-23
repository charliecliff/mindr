//
//  g5TimeCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"
#import <Mantle/Mantle.h>

typedef enum {
    MDRTimeAM = 0,
    MDRTimePM,
} MDRTimeMeridian;

@interface MDRTime : MTLModel <MTLJSONSerializing>

@property(nonatomic) NSInteger hour;
@property(nonatomic) NSInteger minute;
@property(nonatomic) MDRTimeMeridian meridian;

- (NSString *)description;

@end

@interface MDRTimeCondition : MDRCondition

@property(nonatomic, strong, readonly) NSArray *times;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
