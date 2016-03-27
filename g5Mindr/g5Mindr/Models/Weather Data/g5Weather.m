//
//  WXCondition.m
//  SimpleWeather
//
//  Created by Ryan Nystrom on 11/11/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import "g5Weather.h"

@implementation g5Weather

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"humidity": @"main.humidity",
             @"temperature": @"main.temp",
             @"tempHigh": @"main.temp_max",
             @"tempLow": @"main.temp_min",
             @"sunrise": @"sys.sunrise",
             @"sunset": @"sys.sunset",
             @"condition": @"weather",
             @"windBearing": @"wind.deg",
             @"windSpeed": @"wind.speed",
             };
}

+ (NSValueTransformer *)conditionJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *values, BOOL *success, NSError *__autoreleasing *error) {
        return [values firstObject][@"id"];
    } reverseBlock:^id(NSString *str, BOOL *success, NSError *__autoreleasing *error) {
        return @[str];
    }];
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *str, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:str.floatValue];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    }];
}

+ (NSValueTransformer *)sunriseJSONTransformer {
    return [self dateJSONTransformer];
}

+ (NSValueTransformer *)sunsetJSONTransformer {
    return [self dateJSONTransformer];
}

@end
