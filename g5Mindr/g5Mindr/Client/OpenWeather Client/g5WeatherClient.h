//
//  g5WeatherSource.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreLocation;

@protocol g5WeatherClient <NSObject>

- (void)getCurrentWeatherForLocation:(CLLocation *)location withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure;

@end

