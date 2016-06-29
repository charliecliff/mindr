//
//  g5MindrManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderManager.h"
#import "MDRReminderClient.h"

#define REMINDERS @"REMINDERS"

@interface g5ReminderManager ()

@property(nonatomic, strong, readwrite) MDRReminderContext *reminderContext;
@property(nonatomic, strong, readwrite) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *reminders;

@end

@implementation g5ReminderManager

#pragma mark - Singleton

+ (g5ReminderManager *)sharedManager {
    static g5ReminderManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (g5ReminderManager *)init {
    self = [super init];
    if (self != nil) {
        self.reminderIDs = [[NSMutableOrderedSet alloc] init];
        self.reminders = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Getters

- (MDRReminder *)newReminder {
    MDRReminder *newReminder = [[MDRReminder alloc] init];
    return newReminder;
}

- (void)addReminder:(MDRReminder *)reminder {
    [self.reminderIDs addObject:reminder.uid];
    [self.reminders setObject:reminder forKey:reminder.uid];
    [self saveReminders];
}

- (void)removeReminder:(MDRReminder *)reminder {
    [self.reminderIDs removeObject:reminder.uid];
    [self.reminders removeObjectForKey:reminder.uid];
    [self saveReminders];
}

- (MDRReminder *)reminderForIndex:(NSInteger)index {
    NSString *reminderID = [self.reminderIDs objectAtIndex:index];
    return [self reminderForID:reminderID];
}

- (MDRReminder *)reminderForID:(NSString *)reminderID {
    return [self.reminders objectForKey:reminderID];
}

#pragma mark - API Calls

- (void)updateContext {
    [MDRReminderClient postUserContext:self.userContext withSuccess:^{
        
    } withFailure:^{
        
    }];
}

- (void)updateReminders {
    [MDRReminderClient postReminders:self.reminders.allValues withUserID:self.userContext.userID withSuccess:^{
        
    } withFailure:^{
        
    }];
}

#pragma mark - Persistence

- (void)saveReminders {
    
    NSMutableArray *arrayOfReminderDictionaries = [[NSMutableArray alloc] init];
    for (NSString *currentReminderID in self.reminderIDs) {
        MDRReminder *currentReminder = [self.reminders objectForKey:currentReminderID];
        NSDictionary *currentReminderDictionary = [currentReminder encodeToDictionary];
        [arrayOfReminderDictionaries addObject:currentReminderDictionary];
    }
    
    NSDictionary *dictionaryToPersist = @{@"reminders":arrayOfReminderDictionaries};
    [[g5PersistenceManager sharedManager] saveDictionary:dictionaryToPersist withID:REMINDERS];
}

- (void)loadReminders {
    
    self.reminderIDs = [[NSMutableOrderedSet alloc] init];
    self.reminders   = [[NSMutableDictionary alloc] init];
    
    NSDictionary *dictionaryToLoad = [[g5PersistenceManager sharedManager] loadDictionaryWithID:REMINDERS];
    NSArray *arrayOfReminderDictionaries = [dictionaryToLoad objectForKey:@"reminders"];
    
    for (NSDictionary *currentReminderDictionary in arrayOfReminderDictionaries) {
        MDRReminder *currentReminder = [[MDRReminder alloc] initWithDictionary:currentReminderDictionary];
        [self.reminders setObject:currentReminder forKey:currentReminder.uid];
        [self.reminderIDs addObject:currentReminder.uid];
    }
}

@end
