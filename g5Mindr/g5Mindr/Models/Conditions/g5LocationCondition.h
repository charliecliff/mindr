//
//  g5LocationCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"
#import <CoreLocation/CoreLocation.h>

@interface g5LocationCondition : g5Condition

@property(nonatomic) CLLocationDistance radius;
@property(nonatomic, strong) CLLocation *location;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isValidLocation:(CLLocation *)location;

@end
