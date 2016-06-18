//
//  LocationManager.m
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "MDRLocationMonitor.h"
#import "g5ReminderManager.h" //    a CIRCULAR reference!!!
#import <GoogleMaps/GoogleMaps.h>

@interface MDRLocationMonitor ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *locationServicesEnabledMonitoringTimer;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@end

@implementation MDRLocationMonitor

#pragma mark - Singleton

+ (MDRLocationMonitor *)sharedManager {
    static MDRLocationMonitor *_sharedLocationManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    return _sharedLocationManager;
}

#pragma mark - Init

- (MDRLocationMonitor *)init {
    self = [super init];
    if ( self != nil) {
        [self configureLocationManager];
    }
    return self;
}

- (void)dealloc {
    [self stopMonitoringLocationServices];
}

#pragma mark - Configure

- (void)configureLocationManager {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    _locationManager.delegate = self;
        
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined && [self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationManager requestAlwaysAuthorization];
    }
}

#pragma mark - Location Manager

- (void)startUpdatingLocation {
    [self startMonitoringLocationServices];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    self.currentLocation = location;
    
    [[g5ReminderManager sharedManager] validateReminderConditions];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways) {
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - Monitoring CLLocation Services

- (void)startMonitoringLocationServices {
    self.locationServicesEnabledMonitoringTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(determineLocationServicesAreEnabled) userInfo:nil repeats:YES];
}

- (void)stopMonitoringLocationServices {
    self.locationServicesEnabledMonitoringTimer = nil;
}

- (void)determineLocationServicesAreEnabled {
    if ( ![CLLocationManager locationServicesEnabled] ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE object:nil];
    };
}

#pragma mark - g5Location Source

- (CLLocation *)currentLocation {
    return _currentLocation;
}

#pragma mark - Places Source

- (void)getAddressForLocation:(CLLocation *)location withSuccess:(void (^)(NSString *))success withFailure:(void (^)(NSError *))failure {
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:location.coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        
        if (!error) {
            GMSAddress *firstAddress = response.firstResult;
            
            if (success) {
                success(firstAddress.thoroughfare);
            }
        }
        else {
            if (failure) {
                failure(error);
            }
        }
    }];
}

@end
