#import "g5EditReminderConditionListViewController.h"
#import "g5ReminderManager.h"

@implementation g5EditReminderConditionListViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super initWithReminder:reminder];
    if (self) {
        self.navigationItem.title = @"Edit Conditions";
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidAppear:(BOOL)animated {
    self.bounceNavigationController.delegate = self;
    [self.bounceNavigationController reload];
    [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressRightButton {
    [[g5ReminderManager sharedManager] removeReminder:self.reminder];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didPressLeftButton {
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

@end
