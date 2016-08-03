#import <Foundation/Foundation.h>

@class MDRUserContext;

@interface MDRUserClient : NSObject

+ (void)postContextForUserContext:(MDRUserContext *)context withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure;

@end
