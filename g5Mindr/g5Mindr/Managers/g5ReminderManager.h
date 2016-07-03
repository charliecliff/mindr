//
//  g5MindrManager.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRReminder.h"

@interface g5ReminderManager : NSObject

@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong, readonly) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readonly) NSMutableDictionary *reminders;

/**
 
 */
+ (g5ReminderManager *)sharedManager;

/**
 
 */
- (MDRReminder *)newReminder;

/**
 
 */
- (void)addReminder:(MDRReminder *)reminder;
- (void)removeReminder:(MDRReminder *)reminder;

/**
    Getters
 */
- (MDRReminder *)reminderForIndex:(NSInteger)index;
- (MDRReminder *)reminderForID:(NSString *)reminderID;

/**
 Setters
 */
- (void)setUserID:(NSString *)userID;

/**
    Persistence
 */
- (void)saveReminders;
- (void)loadReminders;

@end
