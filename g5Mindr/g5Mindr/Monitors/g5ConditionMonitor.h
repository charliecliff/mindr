//
//  g5ConditionMonitor.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class g5ConditionMonitor;

@protocol g5ConditionMonitorDelegate <NSObject>

@required
- (void)didUpdateCondition:(g5ConditionMonitor *)conditionMonitor;

@end

@interface g5ConditionMonitor : NSObject

@property(nonatomic, strong) id<g5ConditionMonitorDelegate> delegate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDelegate:(id<g5ConditionMonitorDelegate>)delegate;

- (void)updateMonitoredCondition;

@end
