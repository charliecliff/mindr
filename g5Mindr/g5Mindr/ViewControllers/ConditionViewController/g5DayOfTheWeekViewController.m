//
//  g5WeekDayViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DayOfTheWeekViewController.h"
#import "g5DayOfTheWeekConditionTableViewCell.h"
#import "MDRDayOfTheWeekCondition.h"
#import "g5ConfigAndMacros.h"

@interface g5DayOfTheWeekViewController () <UITableViewDataSource, UITabBarDelegate>

@property (nonatomic, strong) IBOutlet UITableView *dayOfTheWeekTableView;

@end

@implementation g5DayOfTheWeekViewController

#pragma mark - Init

- (instancetype)initWithCondition:(MDRCondition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (condition == nil) {
            self.condition = [[MDRDayOfTheWeekCondition alloc] init];
        }
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = CONDITION_VIEW_CONTROLLER_NAVIGATION_TITLE_FOR_DAY_OF_THE_WEEK;
    self.navigationItem.hidesBackButton = YES;

}

#pragma mark - Set Up

- (g5DayOfTheWeekConditionTableViewCell *)dayOfTheWeekCell {
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    NSArray *topLevelObjects = [resourcesBundle loadNibNamed:@"g5DayOfTheWeekConditionTableViewCell" owner:self options:nil];
    g5DayOfTheWeekConditionTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    return cell;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DAYS_OF_THE_WEEK_ARRAY.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= DAYS_OF_THE_WEEK_ARRAY.count) {
        UITableViewCell *blankCell = [[UITableViewCell alloc] init];
        blankCell.backgroundColor = [UIColor clearColor];
        blankCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return blankCell;
    }
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    NSArray *topLevelObjects = [resourcesBundle loadNibNamed:@"g5DayOfTheWeekConditionTableViewCell" owner:self options:nil];
    g5DayOfTheWeekConditionTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    
    NSString *dayOfTheWeekString = [((MDRDayOfTheWeekCondition *)self.condition) stringForWeekday:(indexPath.row)];
    cell.dayOfTheWeekLabel.text = dayOfTheWeekString;
    
    BOOL shouldSelectCell = [((MDRDayOfTheWeekCondition *)self.condition) containsDayOfTheWeek:(indexPath.row)];

    [cell.backgroundImageView setHidden:!shouldSelectCell];
    [cell.checkMarkImageView setHidden:!shouldSelectCell];
    if (shouldSelectCell)
        [cell.dayOfTheWeekLabel setTextColor:GOLD_COLOR];
    else
        [cell.dayOfTheWeekLabel setTextColor:PERIWINKE_BLUE_COLOR];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= DAYS_OF_THE_WEEK_ARRAY.count)
        return;
    if ([((MDRDayOfTheWeekCondition *)self.condition) containsDayOfTheWeek:(indexPath.row)])
        [((MDRDayOfTheWeekCondition *)self.condition) removeDayOfTheWeek:(indexPath.row)];
    else
        [((MDRDayOfTheWeekCondition *)self.condition) setDayOfTheWeek:(indexPath.row)];
    [self.dayOfTheWeekTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == DAYS_OF_THE_WEEK_ARRAY.count) {
        return 200;
    }
    return 60;
}

@end
