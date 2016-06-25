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

@implementation MDRReminderClient

+ (void)getRemindersWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    NSString *escapedString = [REMINDER_API_GATEWAY stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
//    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
//    [paramaters setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
//    [paramaters setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lon"];
//    [paramaters setObject:@"imperial" forKey:@"units"];
//    [paramaters setObject:APP_ID forKey:@"APPID"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager GET:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *JSON = (NSDictionary *)responseObject;
//        if (success) {
//            success(JSON);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure();
//        }
//    }];
}


+ (void)putReminders:(NSArray *)reminders withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    
//    NSString *escapedString = [CURRENT_WEATHER_ENDPONT stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
//    
//    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
//    [paramaters setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
//    [paramaters setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lon"];
//    [paramaters setObject:@"imperial" forKey:@"units"];
//    [paramaters setObject:APP_ID forKey:@"APPID"];
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer  = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager GET:escapedString parameters:paramaters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *JSON = (NSDictionary *)responseObject;
//        if (success) {
//            success(JSON);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (failure) {
//            failure();
//        }
//    }];
}

@end
