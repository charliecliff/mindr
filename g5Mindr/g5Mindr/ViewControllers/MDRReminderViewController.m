#import "MDRReminderViewController.h"
#import "g5EditReminderConditionListViewController.h"
#import "MDREmoticonSelectionViewController.h"
#import "MDREditReminderTitleViewController.h"
#import "MDRReminderDetailTableViewCell.h"
#import "g5ReminderDetailButtonTableViewCell.h"
#import "g5ReminderManager.h"
#import "g5ConfigAndMacros.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *MDRReminderDetailCellIdentifier = @"reminder_detail_cell";

@implementation MDRReminderDetailTableViewController

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDRReminderDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MDRReminderDetailCellIdentifier];
    if ( indexPath.row == 0 ) {
        cell.titleLabel.text = @"Title";
        cell.explanationLabel.text = self.reminder.title;
    }
    else if ( indexPath.row == 1 ) {
        cell.titleLabel.text = @"Conditions";
    }
    else if ( indexPath.row == 2 ) {
        cell.titleLabel.text = @"Sound";
        cell.explanationLabel.text = self.reminder.title;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

@end

static NSString *MDRReminderDetailEmbedSegue = @"reminder_detail_embed";

@interface MDRReminderViewController () <UITableViewDelegate>

// PROTECTED
@property(nonatomic, strong, readwrite) NSMutableArray *cells;

// OUTLETS
@property (nonatomic, strong) IBOutlet UILabel *emoticonLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *explanationLabel;
@property (nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property (nonatomic, strong) IBOutlet UIImageView *innerRingImageView;

@end

@implementation MDRReminderViewController


#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"Reminder Details";
    self.navigationItem.hidesBackButton = YES;
    
    [self.innerRingImageView.layer setCornerRadius:self.innerRingImageView.frame.size.height/2];
    [self.outerRingImageView.layer setCornerRadius:self.outerRingImageView.frame.size.height/2];
    
    [self setUpBackButton];
    [self bindToReminder];
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

#pragma mark - Set Up

- (void)setUpBackButton {
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"button_back_grey"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButtonView addSubview:backButton];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    
    self.navigationItem.leftBarButtonItem = barBtn;
}

#pragma mark - Binding

- (void)bindToReminder {
    RAC(self.titleLabel, text)       = RACObserve(self.reminder, title);
    RAC(self.explanationLabel, text) = RACObserve(self.reminder, explanation);
    RAC(self.emoticonLabel, text)    = RACObserve(self.reminder, emoji);
}

#pragma mark - Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MDRReminderDetailEmbedSegue]) {
        MDRReminderDetailTableViewController *reminderDetailsTableViewController = (MDRReminderDetailTableViewController *)segue.destinationViewController;
        reminderDetailsTableViewController.reminder = self.reminder;
        reminderDetailsTableViewController.tableView.delegate = self;
        [reminderDetailsTableViewController.tableView reloadData];
    }
}

- (void)segueToConditionViewController {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    
    g5EditReminderConditionListViewController *conditionListVC = [[g5EditReminderConditionListViewController alloc] initWithReminder:self.reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

- (void)segueToEmoticonViewController {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];

    UIStoryboard *emoticonReminderStoryboard = [UIStoryboard storyboardWithName:@"MDREmoticonSelection" bundle:nil];
    MDREmoticonSelectionViewController *vc = [emoticonReminderStoryboard instantiateInitialViewController];
    vc.bounceNavigationController = self.bounceNavigationController;
    vc.reminder = self.reminder;
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
}

- (void)segueToTitleViewController {
    MDREditReminderTitleViewController *vc = [[MDREditReminderTitleViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        [self segueToTitleViewController];
    }
    else if ( indexPath.row == 1 ) {
        [self segueToConditionViewController];
    }
    else if ( indexPath.row == 2 ) {
        
    }
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    [[g5ReminderManager sharedManager] removeReminder:self.reminder];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
    assert(false);
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
