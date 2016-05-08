//
//  g5MindrManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderManager.h"
#import "g5Reminder.h"

#import "g5LocationManager.h"
#import "g5PersistenceManager.h"

#import "g5ConditionMonitor.h"
#import "g5WeatherMonitor.h"

#import "g5WeatherClient.h"
#import "g5OpenWeatherClient.h"

#import <UIKit/UIKit.h>

#define REMINDERS @"REMINDERS"

@interface g5ReminderManager () <g5ConditionMonitorDelegate, g5ConditionDataSource>

@property(nonatomic, strong) NSMutableArray *conditionMonitors;

@property(nonatomic, strong, readwrite) NSMutableOrderedSet *reminderIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *reminders;

@property(nonatomic, strong) g5WeatherMonitor *weatherMonitor;
@property(nonatomic, strong) g5LocationManager *locationManager;

@property(nonatomic, strong) g5LocationManager *locationSource;
@property(nonatomic, strong) g5OpenWeatherClient *weatherClient;

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
//        self.unlockedConditionIDs = [[NSOrderedSet alloc] init];
        self.reminderIDs          = [[NSMutableOrderedSet alloc] init];
        self.reminders            = [[NSMutableDictionary alloc] init];
        
        self.conditionMonitors    = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpWeatherMonitor {
    self.weatherMonitor = [[g5WeatherMonitor alloc] initWithDelegate:self];
    [self.conditionMonitors addObject:self.weatherMonitor];
}


- (void)setUpLocationMonitor {
    self.locationManager = [[g5WeatherMonitor alloc] initWithDelegate:self];
    [self.conditionMonitors addObject:self.weatherMonitor];
}

#pragma mark - Getters

- (g5Reminder *)newReminder {
    g5Reminder *newReminder = [[g5Reminder alloc] init];
    newReminder.datasource = self;
    return newReminder;
}

- (void)addReminder:(g5Reminder *)reminder {
    [self.reminderIDs addObject:reminder.uid];
    [self.reminders setObject:reminder forKey:reminder.uid];
}

- (g5Reminder *)reminderForIndex:(NSInteger)index {
    NSString *reminderID = [self.reminderIDs objectAtIndex:index];
    return [self reminderForID:reminderID];
}

- (g5Reminder *)reminderForID:(NSString *)reminderID {
    return [self.reminders objectForKey:reminderID];
}

#pragma mark - Update

- (void)updateReminders {
    
    for (g5ConditionMonitor *currentConditionMonitor in self.conditionMonitors) {
        [currentConditionMonitor updateMonitoredCondition];
    }
    
    for (g5Reminder *currentReminder in self.reminders.allValues) {
        if ([currentReminder haveConditionsBeenMeet]) {
            [self postPushNotificationForReminder:currentReminder];
        }
    }
}

#pragma mark - Post Push Notifications

- (void)postPushNotificationForReminder:(g5Reminder *)reminder {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:2];
    localNotification.alertBody = reminder.shortExplanation;
    localNotification.alertAction = @"Remind Me";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

#pragma mark - g5ConditionMonitorDelegate

- (void)didUpdateCondition:(g5ConditionMonitor *)conditionMonitor {
    [self validateReminderConditions];
}

- (void)validateReminderConditions {
//    for (g5Reminder *reminder in self.reminders) {
//        if ( [reminder haveConditionsBeenMeet] ) {
//            [self postPushNotificationForReminder:reminder];
//        }
//    }
}

#pragma mark - g5ConditionDataSource

- (NSDate *)currentTimeOfDay {
    return [NSDate date];
}

- (NSDate *)currentDay {
    return [NSDate date];
}

- (NSNumber *)currentTemperature {
    return self.weatherMonitor.currentTemperature;
}

- (kWeatherType)currentWeatherType {
    return self.weatherMonitor.currentWeatherType;
}

- (CLLocation *)currentLocation {
    return nil;
}

#pragma mark - Persistence

- (void)saveReminders {
    
    NSMutableArray *arrayOfReminderDictionaries = [[NSMutableArray alloc] init];
    for (NSString *currentReminderID in self.reminderIDs) {
        g5Reminder *currentReminder = [self.reminders objectForKey:currentReminderID];
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
        g5Reminder *currentReminder = [[g5Reminder alloc] initWithDictionary:currentReminderDictionary];
        [self.reminders setObject:currentReminder forKey:currentReminder.uid];
        [self.reminderIDs addObject:currentReminder.uid];
    }
}

@end
