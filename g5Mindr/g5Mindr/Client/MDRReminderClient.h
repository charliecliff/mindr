#import <Foundation/Foundation.h>

@class CLLocation;

@interface MDRReminderClient : NSObject

+ (void)getRemindersWithUserID:(NSString *)userID
                   withSuccess:(void (^)(NSArray *))success
                   withFailure:(void (^)(void))failure;

+ (void)getReminderWithID:(NSString *)userID
			  withSuccess:(void (^)(NSArray *))success
			  withFailure:(void (^)(void))failure;

+ (void)postReminder:(NSDictionary *)reminderDict
		  withUserID:(NSString *)userID
		 withSuccess:(void (^)(void))success
		 withFailure:(void (^)(void))failure;

+ (void)putReminder:(NSDictionary *)reminderDict
			 withID:(NSString *)reminderID
		withSuccess:(void (^)(void))success
		withFailure:(void (^)(void))failure;

+ (void)deleteReminderWithID:(NSString *)reminderID
				 withSuccess:(void (^)(void))success
				 withFailure:(void (^)(void))failure;


@end
