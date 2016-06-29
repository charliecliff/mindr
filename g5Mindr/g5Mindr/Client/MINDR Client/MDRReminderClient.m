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

static const NSString *userIDKey = @"user_id";
static const NSString *reminderArrayKey = @"reminders";

@implementation MDRReminderClient

+ (void)getRemindersWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    NSString *requestString = [NSString stringWithFormat:@"%@", REMINDER_API_GATEWAY];
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

+ (void)postReminders:(NSArray *)reminders withUserID:(NSString *)userID withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure {
    NSString *requestString = [NSString stringWithFormat:@"%@", REMINDER_API_GATEWAY];
    NSString *escapedString = [requestString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];

    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
    [paramaters setObject:userID forKey:userIDKey];
    [paramaters setObject:reminders forKey:reminderArrayKey];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)getUserContextWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    assert(false);
}

+ (void)postUserContext:(MDRUserContext *)context withSuccess:(void (^)(void))success withFailure:(void (^)(void))failure {
    assert(false);
}

@end
