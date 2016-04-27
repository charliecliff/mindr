//
//  LocationManager.m
//  RideScout
//
//  Created by Brady Miller on 2/18/15.
//  Copyright (c) 2015 RideScout. All rights reserved.
//

#import "g5LocationManager.h"
#import "g5ReminderManager.h" //    a CIRCULAR reference!!!

@interface g5LocationManager ()

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *locationServicesEnabledMonitoringTimer;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@end

@implementation g5LocationManager

#pragma mark - Singleton

+ (g5LocationManager *)sharedManager {
    static g5LocationManager *_sharedLocationManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedLocationManager = [[self alloc] init];
    });
    return _sharedLocationManager;
}

#pragma mark - Init

- (g5LocationManager *)init {
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
//    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.distanceFilter = 50;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
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
    
    [[g5ReminderManager sharedManager] updateReminders];
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

#pragma mark - g5LocationSource

- (CLLocation *)currentLocation {
    return _currentLocation;
}

@end
