#import "MDRReminderClient.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

static const NSString *userIDKey        = @"user_id";
static const NSString *reminderArrayKey = @"reminders";
static const NSString *reminderAPIGateWay = @"http://ec2-54-149-60-145.us-west-2.compute.amazonaws.com:8000/reminder";

@implementation MDRReminderClient

+ (void)getRemindersWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {

    NSString *escapedString = [reminderAPIGateWay stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
    [paramaters setObject:userID forKey:userIDKey];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON = (NSDictionary *)responseObject;
        if (success) {
            success(JSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)postReminder:(NSDictionary *)reminderDict withUserID:(NSString *)userID withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure {
   
    NSString *escapedString = [reminderAPIGateWay stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];

    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] initWithDictionary:reminderDict];
    [paramaters setObject:userID forKey:userIDKey];

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
