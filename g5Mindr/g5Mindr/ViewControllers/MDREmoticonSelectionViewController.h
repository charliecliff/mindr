#import <UIKit/UIKit.h>
#import "HROBounceNavigationController.h"

@class MDRReminder;

@interface MDREmoticonSelectionViewController : UIViewController <HROBounceNavigationDelegate>

// PUBLIC
@property(nonatomic, strong) MDRReminder *reminder;
@property(nonatomic, weak) HROBounceNavigationController *bounceNavigationController;

@end
