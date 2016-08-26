#import "MDRCreateReminderEmoticonSelectionViewController.h"
#import "MDREmoticonCollectionViewController.h"
#import "g5EmoticonCell.h"
#import "HROPageControl.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

#import "MDRCreateReminderTitleViewController.h"

#import "PBJHexagonFlowLayout.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const MDRSelectEmoticonTitle = @"Choose an Emoticon";
static NSString *const MDREmbedEmoticonPageViewController = @"embed_emoticon_page_view_controller";

@interface MDRCreateReminderEmoticonSelectionViewController () <HROBounceNavigationDatasource>

// PRIVATE
@property(nonatomic) NSInteger selectedPageIndex;
@property(nonatomic, strong) NSArray *emoticonImageNames;
@property(nonatomic, strong) NSArray * orderedViewControllers;
@property(nonatomic, strong) UIPageViewController *emoticonPageVC;

// BINDING
@property(nonatomic, weak) IBOutlet HROPageControl *pageControl;

@end

@implementation MDRCreateReminderEmoticonSelectionViewController


#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = MDRSelectEmoticonTitle;
    self.navigationItem.hidesBackButton = YES;
    [self setUpProgressLabel];
}

- (void)viewDidAppear:(BOOL)animated {
    self.bounceNavigationController.delegate = self;
    self.bounceNavigationController.datasource = self;
    [self.bounceNavigationController reload];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setUpProgressLabel {
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    progressLabel.text = @"2/3";
    progressLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:183.0/255.0 blue:230.0/255.0 alpha:1];
    progressLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    [barView addSubview:progressLabel];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barView];
    self.navigationItem.leftBarButtonItem = barBtn;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressRightButton {
    MDRCreateReminderTitleViewController *vc = [[MDRCreateReminderTitleViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    vc.reminder = self.reminder;
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
}

- (void)didPressLeftButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
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
    return BUTTON_CANCEL;
}

- (UIImage *)rightCornerButtonImage {
    return BUTTON_NEXT;
}

@end
