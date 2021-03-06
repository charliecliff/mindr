#import "MDRReminderClient.h"
#import <CoreLocation/CoreLocation.h>
#import <AFNetworking/AFNetworking.h>

static const NSString *userIDKey        	= @"user_id";
static const NSString *reminderIDKey		= @"reminder_id";
static const NSString *reminderArrayKey 	= @"reminders";
static const NSString *reminderAPIGateWay 	= @"http://buoy-api-dev.us-west-2.elasticbeanstalk.com/reminder";

@implementation MDRReminderClient

+ (void)getRemindersWithUserID:(NSString *)userID
                   withSuccess:(void (^)(NSArray *))success
                   withFailure:(void (^)(void))failure {

    NSString *escapedString = [reminderAPIGateWay stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
    [paramaters setObject:userID forKey:userIDKey];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *JSON = (NSArray *)responseObject;
        if (success) {
            success(JSON);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)getReminderWithID:(NSString *)userID
			  withSuccess:(void (^)(NSArray *))success
			  withFailure:(void (^)(void))failure {
	
}

+ (void)postReminder:(NSDictionary *)reminderDict
          withUserID:(NSString *)userID
         withSuccess:(void (^)(void))success
         withFailure:(void (^)(void))failure {
   
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
        NSLog(@"Failure - %@", [operation.responseObject objectForKey:@"description"]);
        if (failure) {
            failure();
        }
    }];
}

+ (void)putReminder:(NSDictionary *)reminderDict
			 withID:(NSString *)reminderID
		withSuccess:(void (^)(void))success
		withFailure:(void (^)(void))failure {
	
	NSString *escapedString = [reminderAPIGateWay stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
	escapedString = [escapedString stringByAppendingString:@"/"];
	escapedString = [escapedString stringByAppendingString:reminderID];

	NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] initWithDictionary:reminderDict];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.requestSerializer  = [AFJSONRequestSerializer serializer];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	[manager PUT:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (success) {
			success();
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (failure) {
			failure();
		}
	}];
}

+ (void)deleteReminderWithID:(NSString *)reminderID
				 withSuccess:(void (^)(void))success
				 withFailure:(void (^)(void))failure {
	
	NSString *escapedString = [reminderAPIGateWay stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
	escapedString = [escapedString stringByAppendingString:@"/"];
	escapedString = [escapedString stringByAppendingString:reminderID];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	manager.requestSerializer  = [AFJSONRequestSerializer serializer];
	manager.responseSerializer = [AFJSONResponseSerializer serializer];
	
	[manager DELETE:escapedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (success) {
			success();
		}
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (failure) {
			failure();
		}
	}];
}
@end
