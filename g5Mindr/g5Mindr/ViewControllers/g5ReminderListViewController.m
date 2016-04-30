//
//  g5ReminderListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderListViewController.h"
#import "g5ReminderViewController.h"
#import "g5ConditionListViewController.h"
#import "g5ReminderTableViewCell.h"
#import "g5ReminderManager.h"
#import "g5Reminder.h"
#import "g5ConfigAndMacros.h"

//  Third-Party
#import "AMWaveTransition.h"
#import "IBCellFlipSegue.h"

@interface g5ReminderListViewController () <UINavigationControllerDelegate> {
    NSMutableArray *cells;
}

@property(nonatomic, strong) UITableViewController *reminderTableViewController;

@end

@implementation g5ReminderListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"Something";

    [self setUpTableView];
    [self setUpCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
}

#pragma mark - Set Up

- (void)setUpTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.rowHeight = 80;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)setUpCells {
    cells = [[NSMutableArray alloc] init];
    
    for (NSString *currentReminderUID in [g5ReminderManager sharedManager].reminderIDs) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        g5ReminderTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        
        if (!cell) {
            UINib *tableCell = [UINib nibWithNibName:@"g5ReminderTableViewCell" bundle:resourcesBundle] ;
            [self.tableView registerNib:tableCell forCellReuseIdentifier:@"g5ReminderTableViewCell"];
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        }
        
        g5Reminder *currentReminder = [[g5ReminderManager sharedManager] reminderForID:currentReminderUID];
        [cell configureWithReminder:currentReminder];
        
        [cells addObject:cell];
    }
}

#pragma mark - Segues

- (void)segueToConditionViewControllerWithReminder:(g5Reminder *)reminder {
    g5ConditionListViewController *conditionListVC = [[g5ConditionListViewController alloc] initWithReminder:reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

- (void)segueToReminderViewControllerWithReminder:(g5Reminder *)reminder {
    assert(false);
//    g5ReminderViewController *vc = [[g5ReminderViewController alloc] initWithReminder:reminder];
//    [self presentViewController:vc animated:YES completion:^{
//        
//    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    g5Reminder *selectedReminder = [[g5ReminderManager sharedManager] reminderForIndex:indexPath.row];    
    [self segueToReminderViewControllerWithReminder:selectedReminder];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5ReminderTableViewCell *cell = [cells objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = cells.count;
    return count;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    [self.bounceNavigationController setNextButtonEnabled:NO];

    [self.bounceNavigationController hideCenterButtonWithCompletion:^{
        [self. bounceNavigationController displayCornerButtonsOntoScreenWithCompletion:nil];
    }];
    
    g5Reminder *newReminder = [[g5ReminderManager sharedManager] newReminder];
    [self segueToConditionViewControllerWithReminder:newReminder];
}

- (void)didPressPreviousButton {
    assert(false);
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
    [self.bounceNavigationController hideCornerButtonsWithCompletion:^{
        [self.bounceNavigationController displayCenterButtonOntoScreenWithCompletion:nil];
    }];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
