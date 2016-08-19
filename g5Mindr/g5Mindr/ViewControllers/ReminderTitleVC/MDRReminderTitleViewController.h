#import <UIKit/UIKit.h>

@class MDRReminder;
@class HROBounceNavigationController;

@interface MDRReminderTitleViewController : UIViewController

@property(nonatomic, strong) MDRReminder *reminder;

@property(nonatomic, weak) HROBounceNavigationController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(MDRReminder *)reminder;

@end
