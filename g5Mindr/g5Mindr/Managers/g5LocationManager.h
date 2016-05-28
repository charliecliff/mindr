//
//  LocationManager.h
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE @"Location Services Are Not Available"

@interface g5LocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong, readonly) CLLocation *currentLocation;

+ (g5LocationManager *)sharedManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)getAddressForLocation:(CLLocation *)location withSuccess:(void (^)(NSString *))success withFailure:(void (^)(NSError *))failure;

@end
