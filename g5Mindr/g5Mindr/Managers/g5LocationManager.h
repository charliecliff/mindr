//
//  LocationManager.h
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "g5LocationDatasource.h"

#define NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE @"Location Services Are Not Available"

@interface g5LocationManager : NSObject <g5LocationDatasource, CLLocationManagerDelegate>

+ (g5LocationManager *)sharedManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

@end
