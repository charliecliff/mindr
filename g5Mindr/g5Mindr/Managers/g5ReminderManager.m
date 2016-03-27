//
//  g5MindrManager.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderManager.h"

#import "g5LocationManager.h"
#import "g5WeatherManager.h"

#import "g5WeatherClient.h"
#import "g5OpenWeatherClient.h"

#import "g5LocationManager.h"

#import "g5Reminder.h"

@interface g5ReminderManager ()

@property(nonatomic, strong, readwrite) NSOrderedSet *unlockedConditionIDs;
@property(nonatomic, strong, readwrite) NSOrderedSet *reminderIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *reminders;

@property(nonatomic, strong) g5WeatherManager *weatherManager;
@property(nonatomic, strong) g5LocationManager *locationManager;

@property(nonatomic, strong) g5LocationManager *locationSource;
@property(nonatomic, strong) g5OpenWeatherClient *weatherClient;

@end

@implementation g5ReminderManager

#pragma mark - Singleton

+ (g5ReminderManager *)sharedManager
{
    static g5ReminderManager *_manager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}

#pragma mark - Init

- (g5ReminderManager *)init
{
    self = [super init];
    if (self != nil) {
        self.unlockedConditionIDs = [[NSOrderedSet alloc] init];
        self.reminderIDs          = [[NSOrderedSet alloc] init];
        self.reminders            = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Getters

- (g5Reminder *)newReminder
{
    return [[g5Reminder alloc] init];
}

- (g5Reminder *)reminderForID:(NSString *)reminderID
{
    return [self.reminders objectForKey:reminderID];
}

#pragma mark - Update

- (void)validateReminderConditions
{
    for (g5Reminder *reminder in self.reminders) {
        if ( [reminder haveConditionsBeenMeet] ) {
            [self postPushNotificationForReminder:reminder];
        }
    }
}

#pragma mark - Post Push Notifications

- (void)postPushNotificationForReminder:(g5Reminder *)reminder
{
    
}

@end
