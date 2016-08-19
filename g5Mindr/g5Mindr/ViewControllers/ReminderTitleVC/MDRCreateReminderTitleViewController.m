#import "MDRCreateReminderTitleViewController.h"
#import "HROBounceNavigationController.h"
#import "g5ReminderManager.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

@implementation MDRCreateReminderTitleViewController

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
    self.navigationItem.title = @"Choose a Title";
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    self.bounceNavigationController.datasource = self;
    [self.bounceNavigationController reload];
    [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    [super viewWillDisappear:animated];
}

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
    return [UIImage imageNamed:@"button_delete"];
}

- (UIImage *)rightCornerButtonImage {
    return [UIImage imageNamed:@"button_back"];
}

@end
