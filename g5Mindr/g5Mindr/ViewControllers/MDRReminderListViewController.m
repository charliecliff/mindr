//
//  g5ReminderListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRReminderListViewController.h"
#import "g5ReminderViewController.h"
#import "g5CreateReminderConditionListViewController.h"
#import "g5ReminderTableViewCell.h"
#import "MDRReminderManager.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import "MDRMessageAndCopy.h"

//  Third-Party
#import "AMWaveTransition.h"
#import "IBCellFlipSegue.h"

@interface MDRReminderListViewController () <UINavigationControllerDelegate>

@property(nonatomic, strong) NSMutableArray *cells;

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIView *containerView;

@property(nonatomic, strong) UIButton *editButton;

@end

@implementation MDRReminderListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = REMINDERS_VC_TITLE;
    
    [self setUpTableView];
//    [self setUpEditButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    
    [self setEmptyInventoryHidden:([MDRReminderManager sharedManager].reminders.count > 0)];
    
    [self refresh];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:YES bounceButton:NO withCompletion:nil];
}

#pragma mark - Set Up

- (void)setUpTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.rowHeight = REMINDERS_VC_ROW_HEIGHT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setUpCells {
    self.cells = [[NSMutableArray alloc] init];
    
    for (NSString *currentReminderUID in [MDRReminderManager sharedManager].reminderIDs) {
        g5ReminderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        
        MDRReminder *currentReminder = [[MDRReminderManager sharedManager] reminderForID:currentReminderUID];
        [cell configureWithReminder:currentReminder];
        
        [self.cells addObject:cell];
    }
}

- (void)setUpEditButton {
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    progressLabel.text = REMINDERS_VC_RIGHT_BAR_BUTTON_COPY;
    progressLabel.textColor = GOLD_COLOR;
    progressLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    
    self.editButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [self.editButton setTitle:REMINDERS_VC_RIGHT_BAR_BUTTON_COPY forState:UIControlStateNormal];
    [self.editButton setTitleColor:GOLD_COLOR forState:UIControlStateNormal];
    self.editButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    
    [barView addSubview:self.editButton];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barView];
    self.navigationItem.rightBarButtonItem = barBtn;
}

#pragma mark - Setters

- (void)setEmptyInventoryHidden:(BOOL)hidden {
    [self.tableView setHidden:!hidden];
//    [self.editButton setHidden:!hidden];
    [self.containerView setHidden:hidden];
}

#pragma mark - Resets

- (void)refresh {
    [self setUpCells];
    [self.tableView reloadData];
}

#pragma mark - Segues

- (void)segueToConditionViewControllerWithReminder:(MDRReminder *)reminder {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];

    g5CreateReminderConditionListViewController *conditionListVC = [[g5CreateReminderConditionListViewController alloc] initWithReminder:reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

- (void)segueToReminderViewControllerWithReminder:(MDRReminder *)reminder {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    
    g5ReminderViewController *vc = [[g5ReminderViewController alloc] initWithReminder:reminder];
    vc.bounceNavigationController = ((mindrBounceNavigationViewController *)self.bounceNavigationController);
    [self.bounceNavigationController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MDRReminder *selectedReminder = [[MDRReminderManager sharedManager] reminderForIndex:indexPath.row];    
    [self segueToReminderViewControllerWithReminder:selectedReminder];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.cells.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.contentView.backgroundColor =  [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    g5ReminderTableViewCell *cell = [self.cells objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger count = self.cells.count;
    return count + 1;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    [self.bounceNavigationController setRightButtonEnabled:NO];
    
    MDRReminder *newReminder = [[MDRReminderManager sharedManager] newReminder];
    [self segueToConditionViewControllerWithReminder:newReminder];
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
