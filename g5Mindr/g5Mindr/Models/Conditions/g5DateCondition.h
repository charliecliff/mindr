//
//  g5DateCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Condition.h"

@interface g5DateCondition : g5Condition

@property(nonatomic, strong) NSArray *dates;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (BOOL)isValidDate:(NSDate *)date;

@end
