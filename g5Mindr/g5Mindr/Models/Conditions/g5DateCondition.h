//
//  g5DateCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"
#import "g5EventDatasource.h"

@interface g5DateCondition : g5Condition

@property(nonatomic, strong) NSArray *dates;
@property(nonatomic, strong) id<g5EventDatasource> datasource;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDates:(NSArray *)dates;

@end
