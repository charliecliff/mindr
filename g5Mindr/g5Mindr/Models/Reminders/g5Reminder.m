//
//  g5Reminder.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5Reminder.h"
#import "g5DateCondition.h"
#import "g5TimeCondition.h"
#import "g5LocationCondition.h"
#import "g5WeatherTypeCondition.h"
#import "g5TemperatureCondition.h"

#import "g5WeatherMonitor.h"
#import "g5LocationManager.h"

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
static NSString *const G5DayOfTheWeekCondition = @"condition_for_day_of_the_week";

@interface g5Reminder ()

@property(nonatomic, strong, readwrite) NSMutableOrderedSet *conditionIDs;
@property(nonatomic, strong, readwrite) NSMutableDictionary *conditions;

@end

@implementation g5Reminder

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
        self.pushNotificationHasSound = NO;
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

- (void)setUpConditionsSet{
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

- (BOOL)hasActiveConditions {
    BOOL hasTimeCondition           = [self.timeCondition isActive];
    BOOL hasDayOfTheWeekCondition   = [self.dayOfTheWeekCondition isActive];
    BOOL hasDateCondition           = [self.dateCondition isActive];
    BOOL hasTemperatureCondition    = [self.temperatureCondition isActive];
    BOOL hasWeatherCondition        = [self.weatherCondition isActive];
    BOOL hasLocationCondition       = [self.locationCondition isActive];
    
    return (hasTimeCondition || hasDayOfTheWeekCondition || hasDateCondition || hasWeatherCondition || hasTemperatureCondition || hasLocationCondition);
}

- (BOOL)hasEmoticon {
    return !(self.emoticonUnicodeCharacter == nil);
}

- (BOOL)haveConditionsBeenMeet {
    BOOL timeIsValid             = [self.timeCondition isValidDate:[self.datasource currentDate]];
    BOOL dayOfTheWeekIsValid     = [self.dayOfTheWeekCondition isValidDate:[self.datasource currentDate]];
    BOOL dateIsValid             = [self.dateCondition isValidDate:[self.datasource currentDate]];
    BOOL temperatureIsValid      = [self.temperatureCondition isValidTemperature:[self.datasource currentTemperature]];
    BOOL weatherConditionIsValid = [self.weatherCondition isValidWeatherType:[self.datasource currentWeatherType]];
    BOOL locationIsValid         = [self.locationCondition isValidLocation:[self.datasource currentLocation]];
    
    return (timeIsValid && dateIsValid && temperatureIsValid && weatherConditionIsValid && locationIsValid && dayOfTheWeekIsValid);
}

- (NSString *)conditionDescription {
    NSString *outputString = @"";
    for (NSString *currentConditionKey in self.conditionIDs) {
        g5Condition *currentCondition = [self.conditions objectForKey:currentConditionKey];
        if ( currentCondition.isActive ) {
            if ( [outputString isEqualToString:@""] ) {
                outputString = [NSString stringWithFormat:@"%@", currentCondition.conditionDescription];
            }
            else {
                outputString = [NSString stringWithFormat:@"%@, %@", outputString, currentCondition.conditionDescription];
            }
        }
    }
    return outputString;
}
- (g5Condition *)getConditionAtIndex:(NSUInteger)index {
    NSNumber *conditionUID = [self.conditionIDs objectAtIndex:index];
    g5Condition *selectedCondition = [self.conditions objectForKey:conditionUID];
    return selectedCondition;
}

- (g5Condition *)getConditionForID:(NSNumber *)conditionID {
    g5Condition *selectedCondition = [self.conditions objectForKey:conditionID];
    return selectedCondition;
}

#pragma mark - Setters

- (void)setCondition:(g5Condition *)condition {
    [self.conditions setObject:condition forKey:condition.uid];
    [self.conditionIDs addObject:condition.uid];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.uid = [dictionary objectForKey:KEY_ID];
    self.isActive = [[dictionary objectForKey:KEY_IS_ACTIVE] boolValue];
    self.shortExplanation = [dictionary objectForKey:KEY_SHORT_EXPLANATION];
    self.emoticonUnicodeCharacter = [dictionary objectForKey:KEY_EMOTICON_UNICODE_CHARACTER];
    
    self.pushNotificationHasSound = [[dictionary objectForKey:KEY_NOTIFICATION_HAS_SOUND] boolValue];
    self.pushNotificationSoundFileName = [dictionary objectForKey:KEY_NOTIFICATION_SOUND_FILE_NAME];
    
    self.isIconOnlyNotification = [[dictionary objectForKey:KEY_IS_ICON_ONLY_NOTIFICATION] boolValue];

    NSDictionary *timeDictionary = [dictionary objectForKey:KEY_TIME_CONDITION];
    self.timeCondition = [[g5TimeCondition alloc] initWithDictionary:timeDictionary];

    NSDictionary *dayOfTheWeekDictionary = [dictionary objectForKey:G5DayOfTheWeekCondition];
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
    [dictionary setObject:dayOfTheWeekDictionary forKey:G5DayOfTheWeekCondition];
    
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
