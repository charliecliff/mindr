#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define NOTIFICATION_LOCATION_SERVICES_ARE_NOT_AVAILABLE @"Location Services Are Not Available"

@interface MDRLocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, strong, readonly) CLLocation *currentLocation;

+ (MDRLocationManager *)sharedManager;

- (void)startUpdatingLocation;
- (void)stopUpdatingLocation;

- (void)getAddressForLocation:(CLLocation *)location withSuccess:(void (^)(NSString *))success withFailure:(void (^)(NSError *))failure;

@end
