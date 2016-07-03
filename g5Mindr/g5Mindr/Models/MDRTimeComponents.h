//
//  MNDRTimeComponents.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/6/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MDRTimeCondition.h"

@interface MDRTimeComponents : NSObject

+ (NSOrderedSet *)hours;
+ (NSOrderedSet *)minutes;
+ (NSOrderedSet *)meridians;

+ (NSInteger)hourFromHourString:(NSString *)stringForHour;
+ (NSInteger)minuteFromString:(NSString *)stringForMinute;
+ (MDRTimeMeridian)meridianFromMeridianString:(NSString *)stringForMeridian;

+ (NSInteger)indexForHour:(NSInteger)hour;
+ (NSInteger)indexForMinute:(NSInteger)minute;
+ (NSInteger)indexForMeridian:(MDRTimeMeridian)meridian;

@end
