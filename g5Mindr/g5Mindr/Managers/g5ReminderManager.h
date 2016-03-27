//
//  g5MindrManager.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class g5Reminder;

@interface g5ReminderManager : NSObject

@property(nonatomic, strong, readonly) NSOrderedSet *unlockedConditionIDs;
@property(nonatomic, strong, readonly) NSOrderedSet *reminderIDs;
@property(nonatomic, strong, readonly) NSMutableDictionary *reminders;

+ (g5ReminderManager *)sharedManager;

- (g5Reminder *)newReminder;
- (g5Reminder *)reminderForID:(NSString *)reminderID;

@end
