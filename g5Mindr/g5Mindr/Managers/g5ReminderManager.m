//
//  g5MindrManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderManager.h"

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
        self.reminderContext = [[MDRReminderContext alloc] init];
        self.reminderIDs = [[NSMutableOrderedSet alloc] init];
        self.reminders = [[NSMutableDictionary alloc] init];
        
        [self bindToWeatherMonitor];
        [self bindToLocationMonitor];
    }
    return self;
}

#pragma mark - Set Up

- (void)bindToWeatherMonitor {
    self.weatherMonitor = [MDRWeatherMonitor sharedMonitor];
    
    RACSignal *signalToUpdateCurrentWeather = RACObserve(self.weatherMonitor, currentWeather);
    __block __typeof(self)blockSelf = self;
    [signalToUpdateCurrentWeather subscribeNext:^(g5Weather *weather) {
        blockSelf.reminderContext.currentTemperature = weather.temperature;
        blockSelf.reminderContext.currentWeatherType = weather.type;
        [blockSelf validateReminderConditions];
    }];
}

- (void)bindToLocationMonitor {
    self.locationMonitor = [MDRLocationMonitor sharedManager];
    
    RACSignal *signalToUpdateCurrentLocation = RACObserve(self.locationMonitor, currentLocation);
    __block __typeof(self)blockSelf = self;
    [signalToUpdateCurrentLocation subscribeNext:^(CLLocation *location) {
        blockSelf.reminderContext.currentLocation = location;
        [blockSelf validateReminderConditions];
    }];
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

#pragma mark - Validations

- (void)validateReminderConditions {
    for (MDRReminder *reminder in self.reminders.allValues) {
        
        [reminder validateWithContext:self.reminderContext];
        
//        if ( [reminder validateWithContext:self.reminderContext] )
//            [self postPushNotificationForReminder:reminder];
    }
}

#pragma mark - Post Push Notifications

- (void)postPushNotificationForReminder:(MDRReminder *)reminder {
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:2];
    localNotification.alertBody = reminder.shortExplanation;
    localNotification.alertAction = @"Remind Me";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
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
