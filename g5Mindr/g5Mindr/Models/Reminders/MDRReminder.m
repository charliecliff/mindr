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

#import "MDRWeatherMonitor.h"
#import "MDRLocationMonitor.h"

#define KEY_ID                          @"KEY_ID"
#define KEY_SHORT_EXPLANATION           @"KEY_SHORT_EXPLANATION"
#define KEY_EMOTICON_UNICODE_CHARACTER  @"KEY_EMOTICON_UNICODE_CHARACTER"
#define KEY_IS_ACTIVE                   @"KEY_IS_ACTIVE"

#define KEY_NOTIFICATION_HAS_SOUND          @"KEY_NOTIFICATION_HAS_SOUND"
#define KEY_NOTIFICATION_SOUND_FILE_NAME    @"KEY_NOTIFICATION_SOUND_FILE_NAME"

#define KEY_IS_ICON_ONLY_NOTIFICATION   @"KEY_IS_ICON_ONLY_NOTIFICATION"

#define KEY_TIME_CONDITION          @"KEY_TIME_CONDITION"
#define KEY_DATE_CONDITION          @"KEY_DATE_CONDITION"
#define KEY_WEATHER_CONDITION       @"KEY_WEATHER_CONDITION"
#define KEY_TEMPERATURE_CONDITION   @"KEY_TEMPERATURE_CONDITION"
#define KEY_LOCATION_CONDITION      @"KEY_LOCATION_CONDITION"

static NSString *const kMDRDayOfTheWeekCondition = @"day_of_the_week";
static NSString *const kMDRDateCondition         = @"date";
static NSString *const kMDRTimeOfDayCondition    = @"time_of_fay";
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

#pragma mark - Init

- (instancetype)init {
    self= [super init];
    if (self != nil) {
        self.conditionIDs = [[NSMutableOrderedSet alloc] init];
        self.conditions   = [[NSMutableDictionary alloc] init];
        
        [self generateUID];

        self.isActive = YES;
        self.shortExplanation = nil;
        self.emoticonUnicodeCharacter = nil;
        self.pushNotificationSoundFileName = @"default";
        self.isIconOnlyNotification = NO;
        
        [self setUpConditionsSet];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self= [super init];
    if (self != nil) {
        self.conditionIDs = [[NSMutableOrderedSet alloc] init];
        self.conditions   = [[NSMutableDictionary alloc] init];
        
        [self parseDictionary:dictionary];
    }
    return self;
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

#pragma mark - Validate

- (BOOL)validateWithContext:(MDRReminderContext *)context {

    BOOL allActiveConditionsAreValid = [self hasActiveConditions];
    for (MDRCondition *currentCondition in self.conditions.allValues) {
        if (currentCondition.isActive) {
            if ( ![currentCondition validateWithContext:context] )
                allActiveConditionsAreValid = NO;
        }
    }
    return allActiveConditionsAreValid;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.uid = [dictionary objectForKey:KEY_ID];
    self.isActive = [[dictionary objectForKey:KEY_IS_ACTIVE] boolValue];
    self.shortExplanation = [dictionary objectForKey:KEY_SHORT_EXPLANATION];
    self.emoticonUnicodeCharacter = [dictionary objectForKey:KEY_EMOTICON_UNICODE_CHARACTER];
    
    self.pushNotificationSoundFileName = [dictionary objectForKey:KEY_NOTIFICATION_SOUND_FILE_NAME];
    
    self.isIconOnlyNotification = [[dictionary objectForKey:KEY_IS_ICON_ONLY_NOTIFICATION] boolValue];

    NSDictionary *timeDictionary = [dictionary objectForKey:KEY_TIME_CONDITION];
    self.timeCondition = [[g5TimeCondition alloc] initWithDictionary:timeDictionary];

    NSDictionary *dayOfTheWeekDictionary = [dictionary objectForKey:kMDRDayOfTheWeekCondition];
    self.dayOfTheWeekCondition = [[g5DayOfTheWeekCondition alloc] initWithDictionary:dayOfTheWeekDictionary];
    
    NSDictionary *dateDictionary = [dictionary objectForKey:KEY_DATE_CONDITION];
    self.dateCondition = [[g5DateCondition alloc] initWithDictionary:dateDictionary];
    
    NSDictionary *temperatureDictionary = [dictionary objectForKey:KEY_TEMPERATURE_CONDITION];
    self.temperatureCondition = [[g5TemperatureCondition alloc] initWithDictionary:temperatureDictionary];
    
    NSDictionary *weatherDictionary = [dictionary objectForKey:KEY_WEATHER_CONDITION];
    self.weatherCondition = [[g5WeatherTypeCondition alloc] initWithDictionary:weatherDictionary];
    
    NSDictionary *locationDictionary = [dictionary objectForKey:KEY_LOCATION_CONDITION];
    self.locationCondition = [[g5LocationCondition alloc] initWithDictionary:locationDictionary];
    
    [self setCondition:self.timeCondition];
    [self setCondition:self.dayOfTheWeekCondition];
    [self setCondition:self.dateCondition];
    [self setCondition:self.temperatureCondition];
    [self setCondition:self.weatherCondition];
    [self setCondition:self.locationCondition];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:self.uid forKey:KEY_ID];
    [dictionary setObject:[NSNumber numberWithBool:self.isActive] forKey:KEY_IS_ACTIVE];
    [dictionary setObject:self.shortExplanation forKey:KEY_SHORT_EXPLANATION];
    [dictionary setObject:self.emoticonUnicodeCharacter forKey:KEY_EMOTICON_UNICODE_CHARACTER];
    
    [dictionary setObject:[NSNumber numberWithBool:self.pushNotificationHasSound] forKey:KEY_NOTIFICATION_HAS_SOUND];
    [dictionary setObject:self.pushNotificationSoundFileName forKey:KEY_NOTIFICATION_SOUND_FILE_NAME];
    
    [dictionary setObject:[NSNumber numberWithBool:self.isIconOnlyNotification] forKey:KEY_IS_ICON_ONLY_NOTIFICATION];

    NSDictionary *timeDictionary = [self.timeCondition encodeToDictionary];
    [dictionary setObject:timeDictionary forKey:KEY_TIME_CONDITION];

    NSDictionary *dayOfTheWeekDictionary = [self.dayOfTheWeekCondition encodeToDictionary];
    [dictionary setObject:dayOfTheWeekDictionary forKey:kMDRDayOfTheWeekCondition];
    
    NSDictionary *dateDictionary = [self.dateCondition encodeToDictionary];
    [dictionary setObject:dateDictionary forKey:KEY_DATE_CONDITION];
    
    NSDictionary *temperatureDictionary = [self.temperatureCondition encodeToDictionary];
    [dictionary setObject:temperatureDictionary forKey:KEY_TEMPERATURE_CONDITION];
    
    NSDictionary *weatherDictionary = [self.weatherCondition encodeToDictionary];
    [dictionary setObject:weatherDictionary forKey:KEY_WEATHER_CONDITION];
    
    NSDictionary *locationDictionary = [self.locationCondition encodeToDictionary];
    [dictionary setObject:locationDictionary forKey:KEY_LOCATION_CONDITION];
    
    return dictionary;
}

@end
