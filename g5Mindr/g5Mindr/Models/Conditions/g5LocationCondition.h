//
//  g5LocationCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"
#import "g5LocationDatasource.h"

@interface g5LocationCondition : g5Condition

@property(nonatomic) CLLocationDistance radius;
@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) id<g5LocationDatasource> datasource;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithLocationDatasource:(id<g5LocationDatasource>)datasource;

@end
