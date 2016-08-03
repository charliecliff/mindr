#import <Foundation/Foundation.h>

@class CLLocation;

@interface MDRUserContext : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) CLLocation *currentLocation;

- (NSDictionary *)encodeToDictionary;

@end
