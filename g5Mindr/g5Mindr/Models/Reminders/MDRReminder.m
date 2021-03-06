#import "MDRReminder.h"
#import "MDRDateCondition.h"
#import "MDRTimeCondition.h"
#import "MDRDayOfTheWeekCondition.h"
#import "MDRWeatherTypeCondition.h"
#import "MDRTemperatureCondition.h"

#import "g5ConfigAndMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const kMDRReminderType                     = @"type";
static NSString *const kMDRReminderID                       = @"id";
static NSString *const kMDRReminderTitle                    = @"title";
static NSString *const kMDRReminderEmoticonUnicodeCharacter = @"emoticon";
static NSString *const kMDRReminderNotificationSound        = @"sound";
static NSString *const kMDRReminderDescription              = @"description";
static NSString *const kMDRReminderIsActive                 = @"active";
static NSString *const kMDRReminderConditions               = @"conditions";

static NSString *const kMDRReminderDefaultTitle = @"A New Reminder";
static NSString *const kMDRReminderDefaultUID   = @"INVALID_REMINDER_ID";

@interface MDRReminder ()

// PROTECTED
@property(nonatomic, readwrite) BOOL hasEmoji;
@property(nonatomic, readwrite) BOOL hasActiveConditions;
@property(nonatomic, strong, readwrite) NSString *uid;
@property(nonatomic, strong, readwrite) NSString *explanation;
@property(nonatomic, strong, readwrite) NSMutableDictionary *conditions;
@property(nonatomic, strong, readwrite) NSArray *conditionIDs;

@end

@implementation MDRReminder

#pragma mark - Init

- (instancetype)init {
  self= [super init];
  if (self != nil) {

    self.uid = kMDRReminderDefaultUID;
      
        self.isActive = YES;
        self.title = kMDRReminderDefaultTitle;
        self.emoji = kMDRReminderDefault;
        self.sound = SOUND_FAST_ACTION;
        
        [self setUpConditions];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self= [self init];
    if (self != nil) {
        [self parseDictionary:dictionary];
        [self updateExplanation];
    }
    return self;
}

#pragma mark - Set Up

- (void)setUpConditions {
    __weak __typeof(self)weakSelf = self;

    _conditionIDs = @[
                      g5TimeType,
                      g5DayOfTheWeekType,
                      g5DateType,
                      g5TemperatureType,
//                      g5WeatherType, //TODO: Not Supported
//                      g5LocationType //TODO: Not Supported
                      ];
    
    MDRTimeCondition *timeCondition = [[MDRTimeCondition alloc] init];
    [RACObserve(timeCondition, conditionDescription) subscribeNext:^(NSString *newDescription) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateExplanation];
    }];
    
    MDRDayOfTheWeekCondition *dayOfTheWeekCondition = [[MDRDayOfTheWeekCondition alloc] init];
    [RACObserve(dayOfTheWeekCondition, conditionDescription) subscribeNext:^(NSString *newDescription) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateExplanation];
    }];
    
    MDRDateCondition *dateCondition = [[MDRDateCondition alloc] init];
    [RACObserve(dateCondition, conditionDescription) subscribeNext:^(NSString *newDescription) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateExplanation];
    }];
    
    MDRTemperatureCondition *temperatureCondition = [[MDRTemperatureCondition alloc] init];
    [RACObserve(temperatureCondition, conditionDescription) subscribeNext:^(NSString *newDescription) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateExplanation];
    }];
    
    MDRWeatherTypeCondition *weatherCondition = [[MDRWeatherTypeCondition alloc] init];
    [RACObserve(weatherCondition, conditionDescription) subscribeNext:^(NSString *newDescription) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf updateExplanation];
    }];
    
//    MDRLocationCondition *locationCondition = [[MDRLocationCondition alloc] init];
//    [RACObserve(locationCondition, conditionDescription) subscribeNext:^(NSString *newDescription) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf updateExplanation];
//    }];
    
    _conditions   = [[NSMutableDictionary alloc] init];
    [_conditions setObject:timeCondition forKey:timeCondition.type];
    [_conditions setObject:dayOfTheWeekCondition forKey:dayOfTheWeekCondition.type];
    [_conditions setObject:dateCondition forKey:dateCondition.type];
    [_conditions setObject:temperatureCondition forKey:temperatureCondition.type];
//    [_conditions setObject:weatherCondition forKey:weatherCondition.type]; //TODO
//    [_conditions setObject:locationCondition forKey:locationCondition.type]; //TODO
}

#pragma mark - Getters

- (void)updateExplanation {
  NSString *resultString = @"";
    
  BOOL isFirstCondition = YES;
  for (MDRCondition *currentCondition in self.conditions.allValues) {
    if (currentCondition.isActive) {
      if (isFirstCondition) {
        NSString *conidtionDescriptions = currentCondition.conditionDescription;
        resultString = [NSString stringWithFormat:@"%@%@", resultString, conidtionDescriptions];
        isFirstCondition = NO;
      } else {
        NSString *conidtionDescriptions = currentCondition.conditionDescription;
        resultString = [NSString stringWithFormat:@"%@, %@", resultString, conidtionDescriptions];
      }
    }
  }
  self.explanation = resultString;
}

#pragma mark - Setters 

- (void)setEmoji:(NSString *)emoji {
    _emoji = emoji;
    self.hasEmoji = !( (self.emoji == nil) || ([self.emoji isEqualToString:kMDRReminderDefault]) );
}

#pragma mark - State

- (BOOL)hasActiveConditions {
    BOOL hasActiveConditions = NO;
    for (MDRCondition *currentCondition in self.conditions.allValues) {
        if (currentCondition.isActive)
            hasActiveConditions = YES;
    }
    return hasActiveConditions;
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.uid        = [dictionary objectForKey:kMDRReminderID];
    self.isActive   = [[dictionary objectForKey:kMDRReminderIsActive] boolValue];
    self.title      = [dictionary objectForKey:kMDRReminderTitle];
    self.emoji      = [dictionary objectForKey:kMDRReminderEmoticonUnicodeCharacter];
    self.sound      = [dictionary objectForKey:kMDRReminderNotificationSound];

    for (NSDictionary *currentConditionDictionary in [dictionary objectForKey:kMDRReminderConditions]) {
        NSString *conditionType = [currentConditionDictionary objectForKey:kMDRConditionType];
        MDRCondition *currentCondition;
        if ([conditionType isEqualToString:g5TimeType])
            currentCondition = [[MDRTimeCondition alloc] initWithDictionary:currentConditionDictionary];
        else if ([conditionType isEqualToString:g5DateType])
            currentCondition = [[MDRDateCondition alloc] init];
        else if ([conditionType isEqualToString:g5DayOfTheWeekType])
            currentCondition = [[MDRDayOfTheWeekCondition alloc] initWithDictionary:currentConditionDictionary];
        else if ([conditionType isEqualToString:g5TemperatureType])
            currentCondition = [[MDRTemperatureCondition alloc] initWithDictionary:currentConditionDictionary];
        else if ([conditionType isEqualToString:g5WeatherType])
            currentCondition = [[MDRWeatherTypeCondition alloc] initWithDictionary:currentConditionDictionary];
//        else if ([conditionType isEqualToString:g5LocationType])
//            currentCondition = [[MDRLocationCondition alloc] initWithDictionary:currentConditionDictionary];
        else
            assert(false);
        [self.conditions setObject:currentCondition forKey:currentCondition.type];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
  
  	if (self.uid) {
    	[dictionary setObject:self.uid forKey:kMDRReminderID];
  	}
    [dictionary setObject:self.title forKey:kMDRReminderTitle];
    [dictionary setObject:[NSNumber numberWithBool:self.isActive] forKey:kMDRReminderIsActive];
    [dictionary setObject:self.emoji forKey:kMDRReminderEmoticonUnicodeCharacter];
    [dictionary setObject:self.sound forKey:kMDRReminderNotificationSound];
    [dictionary setObject:self.explanation forKey:kMDRReminderDescription];
	
    NSMutableArray *conditionArray = [[NSMutableArray alloc] init];
    for (MDRCondition *currentCondition in self.conditions.allValues) {
        NSDictionary *currentConditionDictionary = [currentCondition encodeToDictionary];
        [conditionArray addObject:currentConditionDictionary];
    }
    [dictionary setObject:conditionArray forKey:kMDRReminderConditions];
	
    return dictionary;
}

@end
