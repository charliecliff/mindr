//
//  HROTemperatureComponents.m
//  g5Mindr
//
//  Created by Charles Cliff on 6/3/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "HROTemperatureComponents.h"

@implementation HROTemperatureComponents

+ (NSOrderedSet *)degrees {
    return [[NSOrderedSet alloc] initWithObjects:
                     @"0\u00b0",
                     @"1\u00b0",
                     @"2\u00b0",
                     @"3\u00b0",
                     @"4\u00b0",
                     @"5\u00b0",
                     @"6\u00b0",
                     @"7\u00b0",
                     @"8\u00b0",
                     @"9\u00b0",
                     @"10\u00b0",
                     @"11\u00b0",
                     @"12\u00b0",
                     @"13\u00b0",
                     @"14\u00b0",
                     @"15\u00b0",
                     @"16\u00b0",
                     @"17\u00b0",
                     @"18\u00b0",
                     @"19\u00b0",
                     @"20\u00b0",
                     @"21\u00b0",
                     @"22\u00b0",
                     @"23\u00b0",
                     @"24\u00b0",
                     @"25\u00b0",
                     @"26\u00b0",
                     @"27\u00b0",
                     @"28\u00b0",
                     @"29\u00b0",
                     @"30\u00b0",
                     @"31\u00b0",
                     @"32\u00b0",
                     @"33\u00b0",
                     @"34\u00b0",
                     @"35\u00b0",
                     @"36\u00b0",
                     @"37\u00b0",
                     @"38\u00b0",
                     @"39\u00b0",
                     @"40\u00b0",
                     @"41\u00b0",
                     @"42\u00b0",
                     @"43\u00b0",
                     @"44\u00b0",
                     @"45\u00b0",
                     @"46\u00b0",
                     @"47\u00b0",
                     @"48\u00b0",
                     @"49\u00b0",
                     @"50\u00b0",
                     @"51\u00b0",
                     @"52\u00b0",
                     @"53\u00b0",
                     @"54\u00b0",
                     @"55\u00b0",
                     @"56\u00b0",
                     @"57\u00b0",
                     @"58\u00b0",
                     @"59\u00b0",
                     @"60\u00b0",
                     @"61\u00b0",
                     @"62\u00b0",
                     @"63\u00b0",
                     @"64\u00b0",
                     @"65\u00b0",
                     @"66\u00b0",
                     @"67\u00b0",
                     @"68\u00b0",
                     @"69\u00b0",
                     @"70\u00b0",
                     @"71\u00b0",
                     @"72\u00b0",
                     @"73\u00b0",
                     @"74\u00b0",
                     @"75\u00b0",
                     @"76\u00b0",
                     @"77\u00b0",
                     @"78\u00b0",
                     @"79\u00b0",
                     @"80\u00b0",
                     @"81\u00b0",
                     @"82\u00b0",
                     @"83\u00b0",
                     @"84\u00b0",
                     @"85\u00b0",
                     @"86\u00b0",
                     @"87\u00b0",
                     @"88\u00b0",
                     @"89\u00b0",
                     @"90\u00b0",
                     @"91\u00b0",
                     @"92\u00b0",
                     @"93\u00b0",
                     @"94\u00b0",
                     @"95\u00b0",
                     @"96\u00b0",
                     @"97\u00b0",
                     @"98\u00b0",
                     @"99\u00b0",
                     @"100\u00b0",
                     @"101\u00b0",
                     @"102\u00b0",
                     @"103\u00b0",
                     nil];
}


+ (NSOrderedSet *)degreeUnits {
    return [[NSOrderedSet alloc] initWithObjects:@"C",@"F",nil];
}

+ (NSOrderedSet *)prepostions {
    return [[NSOrderedSet alloc] initWithObjects:@"Above",@"Exactly",@"Below",nil];
}

#pragma mark - Utilities

+ (g5TemperatureUnit)temperatureunitFromString:(NSString *)stringForTemperatureUnit {
    if ([stringForTemperatureUnit isEqualToString:@"C"]) {
        return g5TemperatureCelsius;
    }
    if ([stringForTemperatureUnit isEqualToString:@"F"]) {
        return g5TemperatureFahrenheit;
    }
    return -1;
}

+ (NSComparisonResult)comparisonResultFromString:(NSString *)stringForPreposition {
    if ([stringForPreposition isEqualToString:@"Above"]) {
        return NSOrderedAscending;
    }
    if ([stringForPreposition isEqualToString:@"Exactly"]) {
        return NSOrderedSame;
    }
    if ([stringForPreposition isEqualToString:@"Below"]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

+ (NSNumber *)temperatureFromString:(NSString *)temperatureString {
    NSString *newString = [temperatureString substringToIndex:[temperatureString length]-1];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:newString];
    return myNumber;
}

+ (NSInteger)indexForTemperatureUnit:(g5TemperatureUnit)unit {
    if (unit == g5TemperatureCelsius) {
        return 0;
    }
    else if (unit == g5TemperatureFahrenheit) {
        return 1;
    }
    else {
        return -1;
    }
}

+ (NSInteger)indexForComparisonResult:(NSComparisonResult)comparison {
    if (comparison == NSOrderedAscending) {
        NSInteger index = [[HROTemperatureComponents prepostions] indexOfObject:@"Above"];
        return index;
    }
    else if (comparison == NSOrderedDescending  ) {
        NSInteger index = [[HROTemperatureComponents prepostions] indexOfObject:@"Below"];
        return index;
    }
    else {
        return 1;
    }
}

+ (NSInteger)indexForTemperature:(NSNumber *)temperature {
    NSString *temperatureString = [NSString stringWithFormat:@"%@\u00b0", temperature];
    NSInteger index = [[HROTemperatureComponents degrees] indexOfObject:temperatureString];
    return index;
}

@end
