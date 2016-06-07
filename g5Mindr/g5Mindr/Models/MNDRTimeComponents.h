//
//  MNDRTimeComponents.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/6/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNDRTimeComponents : NSObject

+ (NSOrderedSet *)hours;
+ (NSOrderedSet *)minutes;
+ (NSOrderedSet *)meridians;

//+ (g5TemperatureUnit)temperatureunitFromString:(NSString *)stringForTemperatureUnit;
//+ (NSComparisonResult)comparisonResultFromString:(NSString *)stringForPreposition;
//+ (NSNumber *)temperatureFromString:(NSString *)temperatureString;
//
//+ (NSInteger)indexForTemperatureUnit:(g5TemperatureUnit)unit;
//+ (NSInteger)indexForComparisonResult:(NSComparisonResult)comparison;
//+ (NSInteger)indexForTemperature:(NSNumber *)temperature;

@end
