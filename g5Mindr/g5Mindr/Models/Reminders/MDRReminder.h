//
//  g5Reminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MDRCondition;

@interface MDRReminder : NSObject

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
@property(nonatomic, strong, readonly) NSString *explanation;

/**
 
 */
@property(nonatomic, strong) NSString *emoticonUnicodeCharacter;

/**
 
 */
@property(nonatomic, strong, readonly) NSMutableDictionary *conditions;


@property(nonatomic) BOOL isIconOnlyNotification;
@property(nonatomic, strong) NSString *pushNotificationSoundFileName;
@property(nonatomic, strong, readonly) NSArray *conditionIDs;


/**
    Initialization and Persistence
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)encodeToDictionary;

/**
 
 */
- (void)setCondition:(MDRCondition *)condition;

@end
