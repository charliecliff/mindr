//
//  MDRReminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kMDRReminderDefault = @"default";

@class MDRCondition;

@interface MDRReminder : NSObject

#pragma mark - Protected

// PROTECTED
@property(nonatomic, readonly) BOOL hasEmoji;
@property(nonatomic, readonly) BOOL hasActiveConditions;
@property(nonatomic, strong, readonly) NSString *uid;
@property(nonatomic, strong, readonly) NSString *explanation;
@property(nonatomic, strong, readonly) NSMutableDictionary *conditions;
@property(nonatomic, strong, readonly) NSArray *conditionIDs;

// PUBLIC
@property(nonatomic) BOOL isActive;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *emoji;
@property(nonatomic, strong) NSString *sound;

/**
    Initialization and Persistence
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)encodeToDictionary;

@end
