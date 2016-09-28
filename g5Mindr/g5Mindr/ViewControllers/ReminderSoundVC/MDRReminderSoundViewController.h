#import <UIKit/UIKit.h>
#import "MDRReminder.h"
#import "mindrBounceNavigationViewController.h"

@interface MDRReminderSoundViewController : UIViewController

@property(nonatomic, strong) MDRReminder *reminder;
@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(MDRReminder *)reminder;

@end
