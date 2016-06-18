//
//  g5LocationCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"
#import <CoreLocation/CoreLocation.h>

@interface g5LocationCondition : MDRCondition

@property(nonatomic) CLLocationDistance radius;

@property(nonatomic, strong) CLLocation *location;
@property(nonatomic, strong) NSString *address;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isValidLocation:(CLLocation *)location;

@end
