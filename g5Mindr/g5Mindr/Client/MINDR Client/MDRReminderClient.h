//
//  MDRReminderClient.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/25/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDRReminderClient : NSObject

+ (void)getRemindersWithUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure;

+ (void)putReminders:(NSArray *)reminders withUserID:(NSString *)userID withSuccess:(void (^)(NSDictionary *))success withFailure:(void (^)(void))failure;

@end
