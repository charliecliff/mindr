/**
 {
    "user_id": "brandon",
    "title": "tester",
    "active": false,
    "sound": null,
    "description": "a thing when something is true",
    "conditions": [
        {
            "type":"time",
            "attributes": 
            {
                "times": [
                "13:37:00 -0500"
                ]
            }
        }
    ]
 }
 */

#import "MDRTimeCondition.h"

static NSString *const MDRTimeComponentHour          = @"hour";
static NSString *const MDRTimeComponentMinute        = @"minute";
static NSString *const MDRTimeComponentMeridian      = @"meridian";
static NSString *const MDRTimeConditionDateFormatter = @"HH:MM:SS Z";

@implementation MDRTime

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.hour     = 12;
        self.minute   = 0;
        self.meridian = MDRTimePM;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self != nil) {
        self.hour     = [[dictionary objectForKey:MDRTimeComponentHour] integerValue];
        self.minute   = [[dictionary objectForKey:MDRTimeComponentMinute] integerValue];
        self.meridian = [[dictionary objectForKey:MDRTimeComponentMeridian] intValue];
    }
    return self;
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSNumber numberWithInteger:self.hour] forKey:MDRTimeComponentHour];
    [dictionary setObject:[NSNumber numberWithInteger:self.minute] forKey:MDRTimeComponentMinute];
    [dictionary setObject:[NSNumber numberWithInteger:self.meridian] forKey:MDRTimeComponentMeridian];
    return dictionary;
}

//TODO Edit?
- (NSString *)description {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.hour = self.hour;
    if (dateComponents.hour == 12 && self.meridian == MDRTimeAM)
        dateComponents.hour = 0;
    if (dateComponents.hour != 12 && self.meridian == MDRTimePM)
        dateComponents.hour = dateComponents.hour + 12;
    dateComponents.minute = self.minute;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *timeOfDayDate = [gregorianCalendar dateFromComponents:dateComponents];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle =  NSDateFormatterShortStyle;
    return [formatter stringFromDate:timeOfDayDate];
}

@end

static NSString *const MDRTimeComponentTimes = @"times";

@interface MDRTimeCondition ()

@property(nonatomic, strong, readwrite) NSMutableArray *times;

@end

@implementation MDRTimeCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        [self parseDictionary:dictionary[kMDRConditionAttributes]];
        [self updateDescription];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type = g5TimeType;
        self.times = [[NSMutableArray alloc] initWithObjects:[[MDRTime alloc] init], nil];
        [self updateDescription];
    }
    return self;
}

- (void)updateDescription {
    if (self.isActive) {
        NSString *dateString = @"At ";
        for (MDRTime *currentTime in self.times) {
            dateString = [NSString stringWithFormat:@"%@ %@ or at ", dateString, currentTime.description];
        }
        NSRange rangeSpace = [dateString rangeOfString:@" or at " options:NSBackwardsSearch];
        dateString = [dateString stringByReplacingCharactersInRange:rangeSpace withString:@""];
        self.conditionDescription = dateString;;
    }
    else
        self.conditionDescription = @"TIME";
}

#pragma mark - Time Management (LOL!!!)

- (void)addTime:(MDRTime *)time {
    [self.times addObject:time];
    [self updateDescription];
}

- (void)removeTime:(MDRTime *)time {
    [self.times removeObject:time];
    [self updateDescription];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfTimeDictionaries = [dictionary objectForKey:kMDRConditionAttributes];
    for (NSDictionary *currentDictionary in arrayOfTimeDictionaries) {
        MDRTime *currentTime = [[MDRTime alloc] initWithDictionary:currentDictionary];
        [self addTime:currentTime];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *timesArray = [[NSMutableArray alloc] init];
    for (MDRTime *currentTime in self.times) {
        [timesArray addObject:[currentTime encodeToDictionary]];
    }
    [attributeDictionary setObject:timesArray forKey:MDRTimeComponentTimes];
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
