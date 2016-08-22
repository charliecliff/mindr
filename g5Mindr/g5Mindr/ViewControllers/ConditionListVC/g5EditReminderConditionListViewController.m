#import "g5EditReminderConditionListViewController.h"
#import "g5ReminderManager.h"

@interface g5EditReminderConditionListViewController () <HROBounceNavigationDatasource>

@end

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
    self.bounceNavigationController.datasource = self;
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

#pragma mark - HROBounceNavigationDatasource

- (UIColor *)rightButtonFillColor {
    return DELETE_FILL_COLOR;
}

- (UIColor *)leftButtonFillColor {
    return SECONDARY_FILL_COLOR;
}

- (UIColor *)strokeColor {
    return PRIMARY_STROKE_COLOR;
}

- (UIColor *)borderColor {
    return SECONDARY_FILL_COLOR;
}

- (UIColor *)textColor {
    return [UIColor whiteColor];
}

- (UIImage *)leftCornerButtonImage {
    return BUTTON_BACK;
}

- (UIImage *)rightCornerButtonImage {
    return BUTTON_DELETE;
}

@end
