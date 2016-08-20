#import "g5CreateReminderConditionListViewController.h"
#import "MDRCreateReminderEmoticonSelectionViewController.h"

@interface g5CreateReminderConditionListViewController () <HROBounceNavigationDatasource, HROBounceNavigationDelegate>

@end

@implementation g5CreateReminderConditionListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpProgressLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bounceNavigationController.datasource = self;
    self.bounceNavigationController.delegate = self;
    [self.bounceNavigationController reload];
    [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
}

- (void)reload {
    if ([super.reminder hasActiveConditions]) {
        [self.bounceNavigationController setRightButtonEnabled:YES];
    }
    else {
        [self.bounceNavigationController setRightButtonEnabled:NO];
    }
    [self.tableView reloadData];
}

#pragma mark - Set Up

- (void)setUpProgressLabel {
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    progressLabel.text = @"1/3";
    progressLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:183.0/255.0 blue:230.0/255.0 alpha:1];
    progressLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    [barView addSubview:progressLabel];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barView];
    self.navigationItem.leftBarButtonItem = barBtn;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressRightButton {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MDREmoticonSelection" bundle:nil];
    MDRCreateReminderEmoticonSelectionViewController *vc = [sb instantiateViewControllerWithIdentifier:@"MDRCreateEmoticonSelectionViewController"];
    vc.reminder = self.reminder;
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
}

- (void)didPressLeftButton {
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HROBounceNavigationDatasource

- (UIColor *)rightButtonFillColor {
    return PRIMARY_FILL_COLOR;
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
    return [UIImage imageNamed:@"button_next"];
}

- (UIImage *)rightCornerButtonImage {
    return [UIImage imageNamed:@"button_cancel"];
}

@end
