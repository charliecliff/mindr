#import <Foundation/Foundation.h>
#import "MDRUserContext.h"

@class MDRLocationManager;

@interface MDRUserManager : NSObject

/**
 @discussion
 */
@property (nonatomic, strong, readonly) MDRUserContext *currentUserContext;

/**
 @discussion
 */
+ (MDRUserManager *)sharedManager;

/**
 @discussion
 */
- (void)setUserID:(NSString *)userID;

/**
 @discussion
 */
- (void)bindToLocationManager:(MDRLocationManager *)locationManager;

@end
