//
//  MDRReminderClient.m
//  g5Mindr
//
//  Created by Charles Cliff on 6/25/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRReminderClient.h"
#import <AFNetworking/AFNetworking.h>

#define REMINDER_API_GATEWAY @"http://ec2-54-149-60-145.us-west-2.compute.amazonaws.com:8000/reminder"

static const NSString *userIDKey        = @"user_id";
static const NSString *userLatitudeKey  = @"lat";
static const NSString *userLongitudeKey = @"lng";

static const NSString *reminderArrayKey = @"reminders";

@implementation MDRReminderClient

+ (void)getRemindersWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    NSString *requestString = @"http://ec2-54-149-60-145.us-west-2.compute.amazonaws.com:8000/reminder";
    NSString *escapedString = [requestString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
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
    NSString *requestString = @"http://ec2-54-149-60-145.us-west-2.compute.amazonaws.com:8000/reminder";
    NSString *escapedString = [requestString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];

    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] initWithDictionary:reminderDict];
    [paramaters setObject:userID forKey:userIDKey];
    [paramaters setObject:@"description" forKey:@"Reminders dont have decriptions you jackass!"];

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

+ (void)getUserContextWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    assert(false);
}

/**
{
    "user_id": "brandon2",
    "lat": 30.25,
    "lng": 90.75
}
*/
+ (void)postConextForUserID:(NSString *)userID withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure {
    NSString *requestString = @"http://ec2-54-149-60-145.us-west-2.compute.amazonaws.com:8000/context";
    NSString *escapedString = [requestString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
    [paramaters setObject:userID forKey:userIDKey];
    [paramaters setObject:[NSNumber numberWithFloat:0.0] forKey:userLatitudeKey];
    [paramaters setObject:[NSNumber numberWithFloat:0.0] forKey:userLongitudeKey];
    
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
