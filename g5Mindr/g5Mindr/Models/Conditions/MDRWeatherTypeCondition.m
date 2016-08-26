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
        self.type = g5WeatherType;
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

#pragma mark - Persistence

- (void)parseDictionary:(NSDictionary *)dictionary {
    self.weatherTypes= [[NSMutableSet alloc] init];
    
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherSunny] boolValue]) {
        [self.weatherTypes addObject:g5WeatherSunny];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherPartlyCloudy] boolValue]) {
        [self.weatherTypes addObject:g5WeatherPartlyCloudy];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherMostlyCloudy] boolValue]) {
        [self.weatherTypes addObject:g5WeatherMostlyCloudy];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherLightRain] boolValue]) {
        [self.weatherTypes addObject:g5WeatherLightRain];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherHeavyRain] boolValue]) {
        [self.weatherTypes addObject:g5WeatherHeavyRain];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherSeverThunderstorm] boolValue]) {
        [self.weatherTypes addObject:g5WeatherSeverThunderstorm];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherFoggy] boolValue]) {
        [self.weatherTypes addObject:g5WeatherFoggy];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherWindy] boolValue]) {
        [self.weatherTypes addObject:g5WeatherWindy];
    }
    if ([(NSNumber *)[dictionary objectForKey:g5WeatherSnowy] boolValue]) {
        [self.weatherTypes addObject:g5WeatherSnowy];
    }
}

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *superDictionary = [NSMutableDictionary dictionaryWithDictionary:[super encodeToDictionary]];
    
    NSMutableDictionary *attributeDictionary = [[NSMutableDictionary alloc] init];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherSunny])] forKey:g5WeatherSunny];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherPartlyCloudy])] forKey:g5WeatherPartlyCloudy];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherMostlyCloudy])] forKey:g5WeatherMostlyCloudy];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherLightRain])] forKey:g5WeatherLightRain];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherHeavyRain])] forKey:g5WeatherHeavyRain];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherSeverThunderstorm])] forKey:g5WeatherSeverThunderstorm];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherFoggy])] forKey:g5WeatherFoggy];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherWindy])] forKey:g5WeatherWindy];
    [attributeDictionary setObject:[NSNumber numberWithBool:([self.weatherTypes containsObject:g5WeatherSnowy])] forKey:g5WeatherSnowy];
    
    [superDictionary setObject:attributeDictionary forKey:kMDRConditionAttributes];
    return superDictionary;
}

@end
