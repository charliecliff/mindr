//
//  g5Reminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Mantle/Mantle.h>

@class MDRReminderContext;
@class MDRCondition;

@interface MDRReminder : MTLModel <MTLJSONSerializing>

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
@property(nonatomic, readonly) BOOL pushNotificationHasSound;

/**
 
 */
@property(nonatomic, strong) NSString *uid;

/**
 
 */
@property(nonatomic, strong) NSString *title;

/**
 
 */
@property(nonatomic, strong) NSString *explanation;

/**
 
 */
@property(nonatomic, strong) NSString *emoticonUnicodeCharacter;

/**
 
 */
@property(nonatomic, strong) NSString *notificationSound;


@property(nonatomic) BOOL isIconOnlyNotification;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *conditionIDs;

/**
 
 */
- (MDRCondition *)conditionForID:(NSString *)coniditionID;

/**
 
 */
- (void)setCondition:(MDRCondition *)condition;

@end
