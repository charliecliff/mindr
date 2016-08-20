#import "MDRUserClient.h"
#import "MDRUserContext.h"
#import <AFNetworking/AFNetworking.h>

static const NSString *reminderAPIGateWay = @"http://buoy-api-dev.us-west-2.elasticbeanstalk.com/context";

@implementation MDRUserClient

+ (void)postContextForUserContext:(MDRUserContext *)context withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure {
    NSString *escapedString = [reminderAPIGateWay stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSDictionary *paramaters = [context encodeToDictionary];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success");
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failure");
        if (failure) {
            failure();
        }
    }];
}

@end
