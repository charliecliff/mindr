//
//  g5OpenWeatherSource.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5OpenWeatherClient.h"
#import <AFNetworking/AFNetworking.h>

#define CURRENT_WEATHER_ENDPONT @"http://api.openweathermap.org/data/2.5/weather"
#define APP_ID @"106fcf52acbc6760aafa2854ff3e7885"

@implementation g5OpenWeatherClient

- (void)getCurrentWeatherForLocation:(CLLocation *)location withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure {
    
    NSString *escapedString = [CURRENT_WEATHER_ENDPONT stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
    [paramaters setObject:[NSNumber numberWithFloat:location.coordinate.latitude] forKey:@"lat"];
    [paramaters setObject:[NSNumber numberWithFloat:location.coordinate.longitude] forKey:@"lon"];
    [paramaters setObject:@"imperial" forKey:@"units"];
    [paramaters setObject:APP_ID forKey:@"APPID"];
    
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

@end
