#import <Foundation/Foundation.h>
#import "MDRReminder.h"

@interface g5ReminderManager : NSObject

/**
 @discussion
 */
@property(nonatomic, readonly) BOOL didLoadReminders;


/**
 @discussion
 */
@property(nonatomic, strong, readonly) NSMutableOrderedSet *reminderIDs;

/**
 @discussion
 */
@property(nonatomic, strong, readonly) NSMutableDictionary *reminders;

/**
 @discussion
 */
+ (g5ReminderManager *)sharedManager;

/**
 @discussion
 */
- (MDRReminder *)newReminder;

/**
 @discussion
 */
- (void)addReminder:(MDRReminder *)reminder;
- (void)removeReminder:(MDRReminder *)reminder;

/**
 @discussion
 */
- (MDRReminder *)reminderForIndex:(NSInteger)index;
- (MDRReminder *)reminderForID:(NSString *)reminderID;

/**
 @discussion
 */
- (void)saveReminders;
- (void)loadReminders;

@end
