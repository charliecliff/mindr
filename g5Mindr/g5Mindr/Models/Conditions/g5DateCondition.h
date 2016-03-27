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

@property(nonatomic, readonly) NSDate *date;
@property(nonatomic, strong) id<g5EventDatasource> datasource;

- (instancetype)initWithEventDatasource:(id<g5EventDatasource>)datasource;

@end
