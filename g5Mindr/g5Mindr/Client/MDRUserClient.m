#import "MDRUserClient.h"
#import "MDRUserContext.h"
#import <AFNetworking/AFNetworking.h>

@implementation MDRUserClient

+ (void)postContextForUserContext:(MDRUserContext *)context withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure {
    NSString *requestString = @"http://ec2-54-149-60-145.us-west-2.compute.amazonaws.com:8000/context";
    NSString *escapedString = [requestString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
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
