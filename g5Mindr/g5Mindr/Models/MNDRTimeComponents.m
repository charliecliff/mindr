//
//  MNDRTimeComponents.m
//  g5Mindr
//
//  Created by Charles Cliff on 6/6/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MNDRTimeComponents.h"

@implementation MNDRTimeComponents

+ (NSOrderedSet *)hours {
    return [[NSOrderedSet alloc] initWithObjects:
            @"01",
            @"02",
            @"03",
            @"04",
            @"05",
            @"06",
            @"07",
            @"08",
            @"09",
            @"10",
            @"11",
            @"12",
            nil];
}

+ (NSOrderedSet *)minutes {
    return [[NSOrderedSet alloc] initWithObjects:
            @"00",
            @"01",
            @"02",
            @"03",
            @"04",
            @"05",
            @"06",
            @"07",
            @"08",
            @"09",
            @"10",
            @"11",
            @"12",
            @"13",
            @"14",
            @"15",
            @"16",
            @"17",
            @"18",
            @"19",
            @"20",
            @"21",
            @"22",
            @"23",
            @"24",
            @"25",
            @"26",
            @"27",
            @"28",
            @"29",
            @"30",
            @"31",
            @"32",
            @"33",
            @"34",
            @"35",
            @"36",
            @"37",
            @"38",
            @"39",
            @"40",
            @"41",
            @"42",
            @"43",
            @"44",
            @"45",
            @"46",
            @"47",
            @"48",
            @"49",
            @"50",
            @"51",
            @"52",
            @"53",
            @"54",
            @"55",
            @"56",
            @"57",
            @"58",
            @"59",
            nil];
}

+ (NSOrderedSet *)meridians {
    return [[NSOrderedSet alloc] initWithObjects:@"AM",@"PM",nil];
}

#pragma mark - Utilities

+ (NSInteger)hourFromHourString:(NSString *)stringForHour {
    return [stringForHour integerValue];
}

+ (NSInteger)minuteFromString:(NSString *)stringForMinute {
    return [stringForMinute integerValue];
}

+ (MDRTimeMeridian)meridianFromMeridianString:(NSString *)stringForMeridian {
    if ( [stringForMeridian isEqualToString:@"AM"] ) {
        return MDRTimeAM;
    }
    else if ( [stringForMeridian isEqualToString:@"PM"] ) {
        return MDRTimePM;
    }
    assert(false);
}

+ (NSInteger)indexForHour:(NSInteger)hour {
    return hour - 1;
}

+ (NSInteger)indexForMinute:(NSInteger)minute {
    return minute;
}

+ (NSInteger)indexForMeridian:(MDRTimeMeridian)meridian {
    if (meridian == MDRTimeAM) {
        return 0;
    }
    if (meridian == MDRTimePM) {
        return 1;
    }
    assert(false);
}

@end
