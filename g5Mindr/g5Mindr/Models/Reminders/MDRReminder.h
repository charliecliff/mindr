//
//  g5Reminder.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class MDRReminderContext;
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
@property(nonatomic, readonly) BOOL pushNotificationHasSound;

/**
 
 */
@property(nonatomic, strong) NSString *uid;

/**
 
 */
@property(nonatomic, strong) NSString *title;

/**
 
 */
@property(nonatomic, strong) NSString *shortExplanation;

/**
 
 */
@property(nonatomic, strong) NSString *emoticonUnicodeCharacter;




@property(nonatomic) BOOL isIconOnlyNotification;
@property(nonatomic, strong) NSString *pushNotificationSoundFileName;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *conditionIDs;




/**
    Initialization and Persistence
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)encodeToDictionary;

/**
 
 */
- (MDRCondition *)conditionForID:(NSString *)coniditionID;

/**
 
 */
- (void)setCondition:(MDRCondition *)condition;

/**
    Validation of Conditions are done by passing in a Reminder Context.
 */
- (BOOL)validateWithContext:(MDRReminderContext *)conext;

@end
