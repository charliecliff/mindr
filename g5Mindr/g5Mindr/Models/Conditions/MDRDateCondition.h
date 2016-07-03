//
//  g5DateCondition.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRCondition.h"

@interface MDRDateCondition : MDRCondition

@property(nonatomic, strong) NSMutableArray *dates;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
