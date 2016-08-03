#import "MDRUserContext.h"
#import <CoreLocation/CoreLocation.h>

static const NSString *userIDKey        = @"user_id";
static const NSString *userLatitudeKey  = @"lat";
static const NSString *userLongitudeKey = @"lng";

@implementation MDRUserContext

- (NSDictionary *)encodeToDictionary {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.userID forKey:userIDKey];
    [dictionary setObject:[NSNumber numberWithFloat:self.currentLocation.coordinate.latitude] forKey:userLatitudeKey];
    [dictionary setObject:[NSNumber numberWithFloat:self.currentLocation.coordinate.longitude] forKey:userLongitudeKey];
    return dictionary;
}

@end
