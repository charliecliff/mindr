/**
 "type":"weather",
 "attributes": {
    "sunny": true,
    "partly_cloudy": false,
    "mostly_cloudy": true,
    "light_rain": true,
    "heavy_rain": true,
    "severe_thunderstorm": true,
    "foggy": false,
    "windy": false,
    "snowy": false
    } 
 */

#import "MDRWeatherTypeCondition.h"

static NSString *const kMDRConditionWeatherTypes = @"weather_types";

NSString *const g5WeatherSunny              = @"weather_mostlysunny";
NSString *const g5WeatherPartlyCloudy       = @"weather_partlycloudy";
NSString *const g5WeatherMostlyCloudy       = @"weather_mostlycloudy";
NSString *const g5WeatherLightRain          = @"weather_rainy";
NSString *const g5WeatherHeavyRain          = @"weather_reallyrainy";
NSString *const g5WeatherSeverThunderstorm  = @"weather_thunderstorms";
NSString *const g5WeatherFoggy              = @"weather_foggy";
NSString *const g5WeatherWindy              = @"weather_windy";
NSString *const g5WeatherSnowy              = @"weather_snowy";

@interface MDRWeatherTypeCondition ()

@property(nonatomic, strong) NSMutableSet *weatherTypes;

@end

@implementation MDRWeatherTypeCondition

#pragma mark - Init

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        self.type        = g5WeatherType;
        self.weatherTypes= [[NSMutableSet alloc] init];
        [self parseDictionary:dictionary[kMDRConditionAttributes]];
        [self updateDescription];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.type        = g5WeatherType;
        self.weatherTypes= [[NSMutableSet alloc] initWithObjects:g5WeatherSunny, nil];
        [self updateDescription];
    }
    return self;
}

- (void)updateDescription {
    if (self.isActive) {
        BOOL isFirstCondition = YES;
        NSString *resultString = @"When it's";
        for (NSString *currentWeatherType in self.weatherTypes) {
            NSString *weatherString = [MDRWeatherTypeCondition descriptionFromWeatherType:currentWeatherType];
            if (isFirstCondition) {
                isFirstCondition = NO;
                resultString = [NSString stringWithFormat:@"%@ %@", resultString, weatherString];
            }
            else
                resultString = [NSString stringWithFormat:@"%@ or %@", resultString, weatherString];
        }
        self.conditionDescription = resultString;
    }
    else
        self.conditionDescription = @"WEATHER";
    
}

#pragma mark - Weather Type Management

- (BOOL)containsWeatherType:(NSString *)weatherType {
    return [self.weatherTypes containsObject:weatherType];
}

- (void)removeWeatherType:(NSString *)weatherType {
    [self.weatherTypes removeObject:weatherType];
    [self updateDescription];
}

- (void)addWeatherType:(NSString *)weatherType {
    [self.weatherTypes addObject:weatherType];
    [self updateDescription];
}

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    NSArray *arrayOfWeatherTypes = [dictionary objectForKey:kMDRConditionWeatherTypes];
    self.weatherTypes = [NSMutableSet setWithArray:arrayOfWeatherTypes];
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:self.weatherTypes.allObjects forKey:kMDRConditionWeatherTypes];
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

#pragma mark - Class Helpers

+ (NSString *)descriptionFromWeatherType:(NSString *)weatherType {
    if ([weatherType isEqualToString:g5WeatherSunny])
        return @"Sunny";
    else if ([weatherType isEqualToString:g5WeatherPartlyCloudy])
        return @"Partly Cloudy";
    else if ([weatherType isEqualToString:g5WeatherMostlyCloudy])
        return @"Mostly Cloudy";
    else if ([weatherType isEqualToString:g5WeatherLightRain])
        return @"Lightly Raining";
    else if ([weatherType isEqualToString:g5WeatherHeavyRain])
        return @"Heavily Raining";
    else if ([weatherType isEqualToString:g5WeatherSeverThunderstorm])
        return @"Stormy";
    else if ([weatherType isEqualToString:g5WeatherFoggy])
        return @"Foggy";
    else if ([weatherType isEqualToString:g5WeatherWindy])
        return @"Windy";
    else if ([weatherType isEqualToString:g5WeatherSnowy])
        return @"Snowing";
    return nil;
}

/**
- (void)parseDictionary:(NSDictionary *)dictionary {
    self.daysOfTheWeek = [[NSMutableSet alloc] init];
    
    if ([(NSNumber *)[dictionary objectForKey:@"monday"] boolValue]) {
        [self setDayOfTheWeek:0];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"tuesday"] boolValue]) {
        [self setDayOfTheWeek:1];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"wednesday"] boolValue]) {
        [self setDayOfTheWeek:2];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"thursday"] boolValue]) {
        [self setDayOfTheWeek:3];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"friday"] boolValue]) {
        [self setDayOfTheWeek:4];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"saturday"] boolValue]) {
        [self setDayOfTheWeek:5];
    }
    if ([(NSNumber *)[dictionary objectForKey:@"sunday"] boolValue]) {
        [self setDayOfTheWeek:6];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:0]])] forKey:@"monday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:1]])] forKey:@"tuesday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:2]])] forKey:@"wednesday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:3]])] forKey:@"thursday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:4]])] forKey:@"friday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:5]])] forKey:@"saturday"];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.daysOfTheWeek containsObject:[NSNumber numberWithUnsignedInteger:6]])] forKey:@"sunday"];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}
*/
@end
