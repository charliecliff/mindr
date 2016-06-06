//
//  HROTemperatureComponents.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/3/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "g5TemperatureCondition.h"

@interface HROTemperatureComponents : NSObject

+ (NSOrderedSet *)degrees;
+ (NSOrderedSet *)degreeUnits;
+ (NSOrderedSet *)prepostions;

+ (g5TemperatureUnit)temperatureunitFromString:(NSString *)stringForTemperatureUnit;
+ (NSComparisonResult)comparisonResultFromString:(NSString *)stringForPreposition;
+ (NSNumber *)temperatureFromString:(NSString *)temperatureString;

+ (NSInteger)indexForTemperatureUnit:(g5TemperatureUnit)unit;
+ (NSInteger)indexForComparisonResult:(NSComparisonResult)comparison;
+ (NSInteger)indexForTemperature:(NSNumber *)temperature;

@end
