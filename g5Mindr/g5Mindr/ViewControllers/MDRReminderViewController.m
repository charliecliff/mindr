#import "MDRReminderViewController.h"

#import "g5EditReminderConditionListViewController.h"
#import "MDREditReminderEmoticonSelectionViewController.h"
#import "MDREditReminderTitleViewController.h"
#import "MDRReminderSoundViewController.h"

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
        cell.explanationLabel.text = self.reminder.sound;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
//    return 3;
}

@end

static NSString *MDRReminderDetailEmbedSegue = @"reminder_detail_embed";

@interface MDRReminderViewController () <UITableViewDelegate>

// PRIVATE
@property (nonatomic, weak) UITableViewController *detailVC;

// PROTECTED
@property (nonatomic, strong, readwrite) NSMutableArray *cells;

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
    
    [self bindToReminder];
}

- (void)viewDidAppear:(BOOL)animated {
    self.bounceNavigationController.datasource = self;
    [self.bounceNavigationController reload];
    [self.detailVC.tableView reloadData]; // HMMMMMMM
    [self.bounceNavigationController setLeftButtonEnabled:YES];
    [self.bounceNavigationController setRightButtonEnabled:YES];
    [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
}

#pragma mark - Binding

- (void)bindToReminder {
    RAC(self.titleLabel, text)       = RACObserve(self.reminder, title);
    RAC(self.explanationLabel, text) = RACObserve(self.reminder, explanation);
    RAC(self.emoticonLabel, text)    = RACObserve(self.reminder, emoji);
}

#pragma mark - Actions

- (void)pressBackButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)didPressEmojiButton:(id)sender {
    [self segueToEmoticonViewController];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MDRReminderDetailEmbedSegue]) {
        MDRReminderDetailTableViewController *reminderDetailsTableViewController = (MDRReminderDetailTableViewController *)segue.destinationViewController;
        reminderDetailsTableViewController.reminder = self.reminder;
        reminderDetailsTableViewController.tableView.delegate = self;
        [reminderDetailsTableViewController.tableView reloadData];
        
        self.detailVC = reminderDetailsTableViewController;
    }
}

- (void)segueToConditionViewController {
    g5EditReminderConditionListViewController *conditionListVC = [[g5EditReminderConditionListViewController alloc] initWithReminder:self.reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

- (void)segueToEmoticonViewController {
    UIStoryboard *emoticonReminderStoryboard = [UIStoryboard storyboardWithName:@"MDREmoticonSelection" bundle:nil];
    MDREditReminderEmoticonSelectionViewController *vc = [emoticonReminderStoryboard instantiateViewControllerWithIdentifier:@"MDREditEmoticonSelectionViewController"];
    vc.bounceNavigationController = self.bounceNavigationController;
    vc.reminder = self.reminder;
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
}

- (void)segueToTitleViewController {
    MDREditReminderTitleViewController *vc = [[MDREditReminderTitleViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
}

- (void)segueToNotificationAlertSoundViewController {
    MDRReminderSoundViewController *vc = [[MDRReminderSoundViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
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
        [self segueToNotificationAlertSoundViewController];
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
    return BUTTON_BACK;
}

- (UIImage *)rightCornerButtonImage {
    return BUTTON_DELETE;
}

@end
