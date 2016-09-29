#import "MDREditReminderTitleViewController.h"
#import "HROBounceNavigationController.h"
#import "g5ReminderManager.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

@interface MDREditReminderTitleViewController () <HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@end

@implementation MDREditReminderTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MDRReminderTitleViewController" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"Edit Title";
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated {
  
    self.bounceNavigationController.datasource = self;
    self.bounceNavigationController.delegate = self;
    [self.bounceNavigationController reload];
    [self.bounceNavigationController displayCornerButtons:YES
                                             bottomButton:NO
                                             bounceButton:NO
                                           withCompletion:nil];
  [super viewDidAppear:animated];
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressRightButton {
    [[g5ReminderManager sharedManager] removeReminder:self.reminder];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
