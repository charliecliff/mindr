//
//  g5ConditionMonitor.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionMonitor.h"

@implementation g5ConditionMonitor

#pragma mark - Init

- (instancetype)initWithDelegate:(id<g5ConditionMonitorDelegate>)delegate {
    self = [super init];
    if (self != nil) {
        self.delegate = delegate;
    }
    return delegate;
}

#pragma mark - Over-Write

- (void)updateMonitoredCondition {
    assert(false);
}

@end
