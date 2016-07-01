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


static NSString *const MDRPushToken = @"push_token";

@interface g5ReminderManager ()

@property(nonatomic, strong, readwrite) NSString *userID;
@property(nonatomic, strong, readwrite) MDRUserContext *userContext;
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
        [self loadUserContext];
        
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

#pragma mark - Setters

- (void)setUserID:(NSString *)userID {
    self.userContext.userID = userID;
    [self saveUserContext];
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

- (void)saveUserContext {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    [NSKeyedArchiver archiveRootObject:self.userContext toFile:filePath];
}

- (void)loadUserContext {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"appData"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.userContext = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

- (void)saveReminders {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"reminders"];
    [NSKeyedArchiver archiveRootObject:self.reminders toFile:filePath];
}

- (void)loadReminders {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectoryPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:@"reminders"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.reminders = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

@end
