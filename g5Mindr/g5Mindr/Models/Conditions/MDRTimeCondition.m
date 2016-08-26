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
static NSString *const MDRTimeConditionDateFormatterForServer  = @"HH:MM:SS";
static NSString *const MDRTimeConditionDateFormatterForDisplay = @"hh:mm a";

@implementation MDRTime

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"Z"];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        _timeZoneString = [formatter stringFromDate:[NSDate date]];
        
        _hour     = 12;
        _minute   = 0;
        _meridian = MDRTimeAM;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self != nil) {
        [self parseDateString:string];
    }
    return self;
}

#pragma mark - Parse

- (NSString *)encodeToString {
    NSInteger hourInTwentyFourFormat = self.hour;
    
    if (hourInTwentyFourFormat == 12 && self.meridian == MDRTimeAM) {
        hourInTwentyFourFormat = 0;
    }
    else if (hourInTwentyFourFormat != 12 && self.meridian == MDRTimePM) {
        hourInTwentyFourFormat = hourInTwentyFourFormat + 12;
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%02ld:%02ld:00", (long)hourInTwentyFourFormat, (long)self.minute];
    
    if (_meridian == MDRTimeAM) {
        dateString= [NSString stringWithFormat:@"%@", dateString];
    }
    else if (_meridian == MDRTimePM) {
        dateString= [NSString stringWithFormat:@"%@", dateString];
    }
    
    dateString= [NSString stringWithFormat:@"%@ %@", dateString, self.timeZoneString];

    return dateString;
}

- (void)parseDateString:(NSString *)string {
//    "13:37:00 -0500"
    _timeZoneString = [string substringWithRange:NSMakeRange(string.length - 6, 5)];
    
    NSArray *chunks = [string componentsSeparatedByString: @":"];
    _hour   = [[chunks objectAtIndex:0] integerValue];
    _minute = [[chunks objectAtIndex:1] integerValue];
    
    if (_hour > 12) {
        _hour = _hour - 12;
        _meridian = MDRTimePM;
    }
    else if (_hour == 12) {
        _meridian = MDRTimePM;
    }
    else if (_hour < 12 && _hour > 0) {
        _meridian = MDRTimeAM;
    }
    else {
        _hour = 12;
        _meridian = MDRTimeAM;
    }
    
}

- (NSString *)description {
    NSString *dateString = [NSString stringWithFormat:@"%ld:%02ld", (long)self.hour, (long)self.minute];
    
    if (_meridian == MDRTimeAM) {
        dateString= [NSString stringWithFormat:@"%@ AM", dateString];
    }
    else if (_meridian == MDRTimePM) {
        dateString= [NSString stringWithFormat:@"%@ PM", dateString];
    }
    
    return dateString;
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
    for (NSString *currentTimeString in arrayOfTimeDictionaries) {
        MDRTime *currentTime = [[MDRTime alloc] initWithString:currentTimeString];
        [self addTime:currentTime];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *timesArray = [[NSMutableArray alloc] init];
    for (MDRTime *currentTime in self.times) {
        [timesArray addObject:[currentTime encodeToString]];
    }
    [attributeDictionary setObject:timesArray forKey:MDRTimeComponentTimes];
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
