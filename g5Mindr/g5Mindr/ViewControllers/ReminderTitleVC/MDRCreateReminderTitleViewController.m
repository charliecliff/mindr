#import "MDRCreateReminderTitleViewController.h"
#import "HROBounceNavigationController.h"
#import "g5ReminderManager.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

@implementation MDRCreateReminderTitleViewController

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    assert(false);
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
