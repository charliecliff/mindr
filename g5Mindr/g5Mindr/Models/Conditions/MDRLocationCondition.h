//
//  g5LocationCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"
#import <CoreLocation/CoreLocation.h>

@interface MDRLocationCondition : MDRCondition

@property(nonatomic) CLLocationDistance radius;
@property(nonatomic, strong) CLLocation *location;

@property(nonatomic, strong, readonly) NSString *address;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary; // TODO: Pull this out with MAntle

- (void)refreshAddress;

@end
