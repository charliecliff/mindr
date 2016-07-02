//
//  g5ReminderViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderViewController.h"
#import "g5EditReminderConditionListViewController.h"
#import "g5ReminderDetailSectionTableViewCell.h"
#import "g5ReminderDetailButtonTableViewCell.h"
#import "g5ReminderManager.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderViewController () <g5ReminderButtonCellDelegate>

@property(nonatomic, strong, readwrite) MDRReminder *reminder;
@property(nonatomic, strong, readwrite) NSMutableArray *cells;

@property(nonatomic, strong) IBOutlet UIButton *deleteButton;
@property(nonatomic, strong) IBOutlet UIView *deleteButtonBackgroundView;

@property(nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *innerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *emoticonImageView;

@property(nonatomic, strong) IBOutlet UILabel *emoticonLabel;
@property(nonatomic, strong) IBOutlet UILabel *explanationLabel;

@property(nonatomic, strong) IBOutlet UITableView *reminderDetailTableview;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation g5ReminderViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self != nil) {
        self.reminder = reminder;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.navigationItem.title = @"Reminder";
        self.navigationItem.hidesBackButton = YES;

        [self setUpCells];
        [self setUpBackButton];
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.emoticonImageView setImage:[UIImage imageNamed:self.reminder.emoticonUnicodeCharacter]];
    self.explanationLabel.text = self.reminder.explanation;
    self.emoticonLabel.text = self.reminder.emoticonUnicodeCharacter;
    self.tableViewHeightConstraint.constant = 44 * 3;
    [self.bounceNavigationController setShouldShowTrashCanOnBounceButton:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:YES withCompletion:nil];
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

- (void)setUpCells {
    self.cells = [[NSMutableArray alloc] init];
    
    g5ReminderDetailSectionTableViewCell *cell1 = [self newBlankSectionCell];
    cell1.titleLabel.text = @"Title";
//    [self.cells addObject:cell1];
    
    g5ReminderDetailSectionTableViewCell *cell2 = [self newBlankSectionCell];
    cell2.titleLabel.text = @"Conditions";
    cell2.explanationLabel.text = self.reminder.explanation;
    [self.cells addObject:cell2];

    g5ReminderDetailSectionTableViewCell *cell3 = [self newBlankSectionCell];
    cell3.titleLabel.text = @"Sound";
    cell3.explanationLabel.text = self.reminder.pushNotificationSoundFileName;
//    [self.cells addObject:cell3];

    g5ReminderDetailButtonTableViewCell *cell4 = [self newBlankButtonCell];
    cell4.titleLabel.text = @"Icon-only Notification";
    [cell4 configWithReminder:self.reminder withDelegate:self];
//    [self.cells addObject:cell4];
}

- (g5ReminderDetailSectionTableViewCell *)newBlankSectionCell {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"g5ReminderDetailSectionTableViewCell" owner:self options:nil];
    g5ReminderDetailSectionTableViewCell *cell = [nibObjects objectAtIndex:0];
    return cell;
}

- (g5ReminderDetailButtonTableViewCell *)newBlankButtonCell {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"g5ReminderDetailButtonTableViewCell" owner:self options:nil];
    g5ReminderDetailButtonTableViewCell *cell = [nibObjects objectAtIndex:0];
    return cell;
}

#pragma mark - Refresh

- (void)refresh {

}

#pragma mark - Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segues

- (void)segueToConditionViewControllerWithReminder:(MDRReminder *)reminder {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    
    g5EditReminderConditionListViewController *conditionListVC = [[g5EditReminderConditionListViewController alloc] initWithReminder:reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

#pragma mark - g5ReminderButtonCellDelegate

- (void)didPressSwitchButton {
    self.reminder.isIconOnlyNotification = !self.reminder.isIconOnlyNotification;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        [self segueToConditionViewControllerWithReminder:self.reminder];
    }
    else if ( indexPath.row == 1 ) {
        
    }
    else if ( indexPath.row == 2 ) {
        
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor yellowColor];
    return [self.cells objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
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

@end
