//
//  g5Reminder.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRReminder.h"
#import "g5DateCondition.h"
#import "g5TimeCondition.h"
#import "g5DayOfTheWeekCondition.h"
#import "g5LocationCondition.h"
#import "g5WeatherTypeCondition.h"
#import "g5TemperatureCondition.h"

static NSString *const kMDRReminderType                     = @"type";
static NSString *const kMDRReminderID                       = @"id";
static NSString *const kMDRReminderTitle                    = @"title";
static NSString *const kMDRReminderEmoticonUnicodeCharacter = @"emoticon";
static NSString *const kMDRReminderNotificationSound        = @"sound";
static NSString *const kMDRReminderIsActive                 = @"active";
static NSString *const kMDRReminderConditions               = @"conditions";

@implementation MDRReminder

#pragma mark - Init

- (instancetype)init {
    self= [super init];
    if (self != nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        CFRelease(uuidRef);
        self.uid = (__bridge_transfer NSString *)uuidStringRef;
        
        _conditionIDs = @[g5TimeType, g5DayOfTheWeekType, g5DateType, g5TemperatureType, g5WeatherType, g5LocationType];
        _conditions = [[NSMutableDictionary alloc] init];
        [self setUpConditions];

        self.isActive = YES;
        
        self.title = @"default";
        self.emoticonUnicodeCharacter = @"default";
        self.pushNotificationSoundFileName = @"default";
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self= [super init];
    if (self != nil) {
        _conditionIDs = @[g5TimeType, g5DayOfTheWeekType, g5DateType, g5TemperatureType, g5WeatherType, g5LocationType];
        _conditions   = [[NSMutableDictionary alloc] init];
        [self parseDictionary:dictionary];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpConditions {
    g5TimeCondition *timeCondition = [[g5TimeCondition alloc] init];
    g5DayOfTheWeekCondition *dayOfTheWeekCondition = [[g5DayOfTheWeekCondition alloc] init];
    g5DateCondition *dateCondition = [[g5DateCondition alloc] init];
    g5TemperatureCondition *temperatureCondition = [[g5TemperatureCondition alloc] init];
    g5WeatherTypeCondition *weatherCondition = [[g5WeatherTypeCondition alloc] init];
    g5LocationCondition *locationCondition = [[g5LocationCondition alloc] init];
    
    _conditions   = [[NSMutableDictionary alloc] init];
    [_conditions setObject:timeCondition forKey:timeCondition.type];
    [_conditions setObject:dayOfTheWeekCondition forKey:dayOfTheWeekCondition.type];
    [_conditions setObject:dateCondition forKey:dateCondition.type];
    [_conditions setObject:temperatureCondition forKey:temperatureCondition.type];
    [_conditions setObject:weatherCondition forKey:weatherCondition.type];
    [_conditions setObject:locationCondition forKey:locationCondition.type];
}

#pragma mark - Getters

- (NSString *)explanation {
    NSString *resultString = @"";
    
    BOOL isFirstCondition = YES;
    for (MDRCondition *currentCondition in self.conditions.allValues) {
        if (currentCondition.isActive) {
            if (isFirstCondition) {
                resultString = [NSString stringWithFormat:@"%@%@", resultString, [currentCondition conditionDescription]];
                isFirstCondition = NO;
            }
            else
                resultString = [NSString stringWithFormat:@"%@, %@", resultString, [currentCondition conditionDescription]];
        }
    }
    return resultString;
}

#pragma mark - State

- (BOOL)hasActiveConditions {
    BOOL hasActiveConditions = NO;
    for (MDRCondition *currentCondition in self.conditions.allValues) {
        if (currentCondition.isActive) {
            hasActiveConditions = YES;
        }
    }
    return hasActiveConditions;
}

- (BOOL)hasEmoticon {
    return !(self.emoticonUnicodeCharacter == nil);
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.uid = [dictionary objectForKey:kMDRReminderID];
    self.title = [dictionary objectForKey:kMDRReminderTitle];
    self.isActive = [[dictionary objectForKey:kMDRReminderIsActive] boolValue];
    self.emoticonUnicodeCharacter = [dictionary objectForKey:kMDRReminderEmoticonUnicodeCharacter];
    self.pushNotificationSoundFileName = [dictionary objectForKey:kMDRReminderNotificationSound];

    for (NSDictionary *currentConditionDictionary in [dictionary objectForKey:kMDRReminderConditions]) {
        NSString *conditionType = [currentConditionDictionary objectForKey:kMDRConditionType];
        
        MDRCondition *currentCondition;
        if ([conditionType isEqualToString:g5TimeType]) {
            currentCondition = [[g5TimeCondition alloc] init];
        }
        else if ([conditionType isEqualToString:g5DateType]) {
            currentCondition = [[g5DateCondition alloc] init];
        }
        else if ([conditionType isEqualToString:g5DayOfTheWeekType]) {
            currentCondition = [[g5DayOfTheWeekCondition alloc] init];
        }
        else if ([conditionType isEqualToString:g5TemperatureType]) {
            currentCondition = [[g5TemperatureCondition alloc] init];
        }
        else if ([conditionType isEqualToString:g5WeatherType]) {
            currentCondition = [[g5WeatherTypeCondition alloc] init];
        }
        else if ([conditionType isEqualToString:g5LocationType]) {
            currentCondition = [[g5LocationCondition alloc] init];
        }
        else {
            assert(false);
        }
        [self.conditions setObject:currentCondition forKey:currentCondition.type];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:self.uid forKey:kMDRReminderID];
    [dictionary setObject:self.title forKey:kMDRReminderTitle];
    [dictionary setObject:[NSNumber numberWithBool:self.isActive] forKey:kMDRReminderIsActive];
    [dictionary setObject:self.emoticonUnicodeCharacter forKey:kMDRReminderEmoticonUnicodeCharacter];
    [dictionary setObject:self.pushNotificationSoundFileName forKey:kMDRReminderNotificationSound];
    
    NSMutableArray *conditionArray = [[NSMutableArray alloc] init];
    for (MDRCondition *currentCondition in self.conditions.allValues) {
        NSDictionary *currentConditionDictionary = [currentCondition encodeToDictionary];
        [conditionArray addObject:currentConditionDictionary];
    }
    [dictionary setObject:conditionArray forKey:kMDRReminderConditions];
    
    return dictionary;
}

@end
