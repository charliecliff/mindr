//
//  g5ConditionListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionListViewController.h"
#import "g5EmoticonSelectionViewController.h"
#import "g5TimeConditionViewController.h"
#import "g5DateConditionViewController.h"
#import "g5TemperatureConditionViewController.h"
#import "g5WeatherTypeConditionViewController.h"
#import "g5LocationConditionViewController.h"
#import "g5ConditionTableViewCell.h"
#import "g5Reminder.h"
#import "g5ReminderManager.h"
#import "g5ConfigAndMacros.h"

#import "AMWaveViewController.h"

@interface g5ConditionListViewController () <g5ConditionDelegate, g5ConditionCellDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    NSMutableArray *cells;
}

@end

@implementation g5ConditionListViewController

#pragma mark - Init

- (instancetype)initWithReminder:(g5Reminder *)reminder {
    self = [super init];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"Choose Conditions";

    [self setUpCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
    [self reload];
}

- (void)reload {
    if ([self.reminder hasActiveConditions]) {
        [self.bounceNavigationController setNextButtonEnabled:YES];
    }
    else {
        [self.bounceNavigationController setNextButtonEnabled:NO];
    }
    [self.tableView reloadData];
}

#pragma mark - Set Up

- (void)setUpCells {
    cells = [[NSMutableArray alloc] init];
    
    for (NSNumber *currentConditionUID in self.reminder.conditionIDs) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        g5ConditionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ConditionTableViewCell"];
        if (!cell) {
            UINib *tableCell = [UINib nibWithNibName:@"g5ConditionTableViewCell" bundle:resourcesBundle] ;
            [self.tableView registerNib:tableCell forCellReuseIdentifier:@"g5ConditionTableViewCell"];
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ConditionTableViewCell"];
        }
        cell.delegate = self;
        
        g5Condition *currentCondition = [self.reminder getConditionForID:currentConditionUID];
        if (currentCondition.isActive) {
            [cell configureForActiveCondition:currentCondition];
        }
        else {
            [cell configureForInActiveCondition:currentCondition];
        }
        
        [cells addObject:cell];
    }
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5ConditionTableViewCell *cell = [cells objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = cells.count;
    return rowCount;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    g5Condition *selectedCondition = [self.reminder getConditionAtIndex:selectedRow];
    if (selectedCondition.isActive) {
        [self.bounceNavigationController hideCornerButtonsWithCompletion:^{
            [self.bounceNavigationController displayPreviousButtonOntoScreenWithCompletion:nil];
        }];
        
        g5ConditionViewController *vc = [self viewControllerForCondition:selectedCondition];
        [self.navigationController pushViewController:vc animated:YES];
        [self.delegate didSelectConditionCell];
    }
}

#pragma mark - g5ConditionCell Delegate

- (void)g5Condition:(g5Condition *)condition didSetActive:(BOOL)active {
    condition.isActive = active;
    [self.reminder setCondition:condition];
    [self reload];
}

#pragma mark - g5ConditionViewController Delegate

- (void)didUpdateCondition:(g5Condition *)condition {
    [self.reminder setCondition:condition];
}

#pragma mark - g5ConditionViewController Factory

- (g5ConditionViewController *)viewControllerForCondition:(g5Condition *)condition {
    g5ConditionViewController *vc;
    switch ([condition.uid integerValue]) {
        
        case g5ConditionIDDate:
            vc = [[g5DateConditionViewController alloc] initWithCondition:condition];
            break;
        
        case g5ConditionIDLocation:
            vc = [[g5LocationConditionViewController alloc] initWithCondition:condition];
            break;
        
        case g5ConditionIDTemperature:
            vc = [[g5TemperatureConditionViewController alloc] initWithCondition:condition];
            break;
            
        case g5ConditionIDTime:
            vc = [[g5TimeConditionViewController alloc] initWithCondition:condition];
            break;
        
        case g5ConditionIDWeather:
            vc = [[g5WeatherTypeConditionViewController alloc] initWithCondition:condition];
            break;
        
        default:
            break;
    }
    vc.delegate = self;
    vc.condition = condition;
    return vc;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    [self.bounceNavigationController hidePreviousButtonWithCompletion:^{
        [self.bounceNavigationController displayCornerButtonsOntoScreenWithCompletion:nil];
    }];
    
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

- (void)didPressNextButton {
    g5EmoticonSelectionViewController *vc = [[g5EmoticonSelectionViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPressCancelButton {
    [self.bounceNavigationController hideCornerButtonsWithCompletion:^{
        [self.bounceNavigationController displayCenterButtonOntoScreenWithCompletion:nil];
    }];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end