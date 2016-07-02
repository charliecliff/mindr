//
//  g5MindrManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "MDRReminderManager.h"
#import "MDRReminderClient.h"

#define REMINDERS @"REMINDERS"


static NSString *const MDRPushToken = @"push_token";

@interface MDRReminderManager ()

@property(nonatomic, strong, readwrite) NSString *userID;
@property(nonatomic, strong, readwrite) MDRUserContext *userContext;
@property(nonatomic, strong, readwrite) MDRReminderContext *reminderContext;
@property(nonatomic, strong, readwrite) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *reminders;

@end

@implementation MDRReminderManager

#pragma mark - Singleton

+ (MDRReminderManager *)sharedManager {
    static MDRReminderManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (MDRReminderManager *)init {
    self = [super init];
    if (self != nil) {        
        [self loadUserContext];
        if (self.userContext == nil) {
            self.userContext = [[MDRUserContext alloc] init];
        }
        
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
    [self updateReminders];
    
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
    NSError *error;
    NSArray *remindersJSON = [MTLJSONAdapter JSONArrayFromModels:self.reminders.allValues error:&error];
//    [MDRReminderClient postReminders:remindersJSON withUserID:self.userContext.userID withSuccess:^{
//        
//    } withFailure:^{
//        
//    }];
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
