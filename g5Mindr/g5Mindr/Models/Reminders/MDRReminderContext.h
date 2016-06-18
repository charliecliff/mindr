//
//  MDRReminderContext.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/18/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MDRReminderContext : NSObject

@property(nonatomic, strong) NSDate *currentDate;
@property(nonatomic, strong) NSNumber *currentTemperature;
@property(nonatomic, strong) NSString *currentWeatherType;
@property(nonatomic, strong) CLLocation *currentLocation;

@end
