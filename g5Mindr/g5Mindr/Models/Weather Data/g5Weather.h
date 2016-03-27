//
//  WXCondition.h
//  SimpleWeather
//
//  Created by Ryan Nystrom on 11/11/13.
//  Copyright (c) 2013 Ryan Nystrom. All rights reserved.
//

#import <Mantle.h>

@interface g5Weather : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;
@property (nonatomic, strong) NSDate *sunrise;
@property (nonatomic, strong) NSDate *sunset;
@property (nonatomic, strong) NSNumber *condition;
@property (nonatomic, strong) NSNumber *windBearing;
@property (nonatomic, strong) NSNumber *windSpeed;

@end
