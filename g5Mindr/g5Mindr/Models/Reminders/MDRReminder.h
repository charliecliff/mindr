//
//  g5Reminder.h
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

/**
 
 */
@property(nonatomic, strong, readonly) NSString *explanation;

#pragma mark - Public

/**
 
 */
@property(nonatomic) BOOL isActive;

/**
 
 */
@property(nonatomic, readonly) BOOL hasEmoticon;

/**
 
 */
@property(nonatomic, readonly) BOOL hasActiveConditions;

/**
 
 */
@property(nonatomic, strong) NSString *uid;

/**
 
 */
@property(nonatomic, strong) NSString *title;

/**
 
 */
@property(nonatomic, strong) NSString *pushNotificationSoundFileName;

/**
 
 */
@property(nonatomic, strong) NSString *emoticonUnicodeCharacter;

/**
 
 */
@property(nonatomic, strong) NSMutableDictionary *conditions;
@property(nonatomic, strong, readonly) NSArray *conditionIDs;

/**
    Initialization and Persistence
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)encodeToDictionary;

@end
