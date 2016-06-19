//
//  g5MindrManager.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MDRReminder.h"
#import "MDRReminderContext.h"
#import "MDRWeatherMonitor.h"
#import "MDRLocationMonitor.h"
#import "g5PersistenceManager.h"

@interface g5ReminderManager : NSObject

/**
 
 */
@property(nonatomic, strong, readonly) MDRReminderContext *reminderContext;

/**
 
 */
@property(nonatomic, strong, readonly) NSMutableOrderedSet *reminderIDs;

/**
 
 */
@property(nonatomic, strong, readonly) NSMutableDictionary *reminders;

/**
 All of the Clients that push data to the Reminder Manager
 */
@property(nonatomic, strong) MDRWeatherMonitor *weatherMonitor;
@property(nonatomic, strong) MDRLocationMonitor *locationMonitor;

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
    Updating the Conditions
 */
- (void)validateReminderConditions;

/**
    Persistence
 */
- (void)saveReminders;
- (void)loadReminders;

@end
