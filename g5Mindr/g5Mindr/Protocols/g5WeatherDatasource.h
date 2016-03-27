//
//  g5WeatherSource.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/21/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "g5WeatherClient.h"

typedef enum {
    g5Rain = 0,
    g5Storm,
    g5ClearSky,
    g5Snow,
    g5Tornado
} g5WeatherConditionType;

@protocol g5WeatherDatasource <NSObject>

@required
- (NSNumber *)currentTemperature;
- (g5WeatherConditionType)currentWeatherType;

@end
