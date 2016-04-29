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

@property(nonatomic, strong, readonly) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readonly) NSMutableDictionary *reminders;

+ (g5ReminderManager *)sharedManager;

- (g5Reminder *)newReminder;

- (void)addReminder:(g5Reminder *)reminder;

// Getters
- (g5Reminder *)reminderForIndex:(NSInteger)index;
- (g5Reminder *)reminderForID:(NSString *)reminderID;

// Updating the Conditions
- (void)updateReminders;

// Persistence
- (void)saveReminders;
- (void)loadReminders;

@end
