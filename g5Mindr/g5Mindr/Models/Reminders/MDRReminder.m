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

static NSString *const kMDRReminderUID                      = @"uid";
static NSString *const kMDRReminderTitle                    = @"title";
static NSString *const kMDRReminderExplanation              = @"explanation";
static NSString *const kMDRReminderEmoticonUnicodeCharacter = @"emoticon_unicode_character";
static NSString *const kMDRReminderNotificationSound        = @"notification_sound";


static NSString *const kMDRTimeCondition         = @"time";
static NSString *const kMDRDateCondition         = @"date";
static NSString *const kMDRDayOfTheWeekCondition = @"day_of_the_week";
static NSString *const kMDRTimeOfDayCondition    = @"time_of_day";
static NSString *const kMDRLocationCondition     = @"location";
static NSString *const kMDRWeatherCondition      = @"weather";
static NSString *const kMDRTemperatureCondition  = @"temperature";

@interface MDRReminder ()

@property(nonatomic, strong, readwrite) NSMutableOrderedSet *conditionIDs;

/**
 The Conditions Dictionary
 */
@property(nonatomic, strong) NSMutableDictionary *conditions;

/**
 The Conditions
 */
@property(nonatomic, strong) g5TimeCondition *timeCondition;
@property(nonatomic, strong) g5DayOfTheWeekCondition *dayOfTheWeekCondition;
@property(nonatomic, strong) g5DateCondition *dateCondition;
@property(nonatomic, strong) g5TemperatureCondition *temperatureCondition;
@property(nonatomic, strong) g5WeatherTypeCondition *weatherCondition;
@property(nonatomic, strong) g5LocationCondition *locationCondition;

@end

@implementation MDRReminder

#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": kMDRReminderUID,
             @"title": kMDRReminderTitle,
             @"explanation": kMDRReminderExplanation,
             @"emoticonUnicodeCharacter": kMDRReminderEmoticonUnicodeCharacter,
             @"notificationSound": kMDRReminderNotificationSound,
             @"timeCondition":kMDRTimeCondition};
}

#pragma mark - Set Up

- (void)setUpConditionsSet {
    self.timeCondition          = [[g5TimeCondition alloc] init];
    self.dayOfTheWeekCondition  = [[g5DayOfTheWeekCondition alloc] init];
    self.dateCondition          = [[g5DateCondition alloc] init];
    self.temperatureCondition   = [[g5TemperatureCondition alloc] init];
    self.weatherCondition       = [[g5WeatherTypeCondition alloc] init];
    self.locationCondition      = [[g5LocationCondition alloc] init];
    
    [self setCondition:self.timeCondition];
    [self setCondition:self.dayOfTheWeekCondition];
    [self setCondition:self.dateCondition];
    [self setCondition:self.temperatureCondition];
    [self setCondition:self.weatherCondition];
    [self setCondition:self.locationCondition];
}

- (void)generateUID {
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    self.uid = (__bridge_transfer NSString *)uuidStringRef;
}

#pragma mark - Getters

- (NSString *)shortExplanation {
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

- (MDRCondition *)conditionForID:(NSString *)coniditionID {
    return [self.conditions objectForKey:coniditionID];
}

#pragma mark - Setters

- (void)setCondition:(MDRCondition *)condition {
    [self.conditions setObject:condition forKey:condition.uid];
    [self.conditionIDs addObject:condition.uid];
}

#pragma mark - Booleans

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

@end
