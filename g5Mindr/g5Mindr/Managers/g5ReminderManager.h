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

//@property(nonatomic, strong, readonly) NSOrderedSet *unlockedConditionIDs;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readonly) NSMutableDictionary *reminders;

+ (g5ReminderManager *)sharedManager;

- (g5Reminder *)newReminder;

- (void)addReminder:(g5Reminder *)reminder;

- (g5Reminder *)reminderForID:(NSString *)reminderID;

- (void)updateReminders;

@end
