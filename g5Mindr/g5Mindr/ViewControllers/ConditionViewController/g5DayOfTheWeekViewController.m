//
//  g5WeekDayViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DayOfTheWeekViewController.h"
#import "g5DayOfTheWeekConditionTableViewCell.h"
#import "g5DayOfTheWeekCondition.h"

@interface g5DayOfTheWeekViewController ()

@property (nonatomic, strong) IBOutlet UITableView *dayOfTheWeekTableView;

@end

@implementation g5DayOfTheWeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5DayOfTheWeekConditionTableViewCell *cell = [self.dayOfTheWeekTableView dequeueReusableCellWithIdentifier:@"day_of_the_week_cell"];
    if (!cell) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        UINib *tableCell = [UINib nibWithNibName:@"g5DayOfTheWeekConditionTableViewCell" bundle:resourcesBundle] ;
        [self.dayOfTheWeekTableView registerNib:tableCell forCellReuseIdentifier:@"day_of_the_week_cell"];
        cell = [self.dayOfTheWeekTableView dequeueReusableCellWithIdentifier:@"day_of_the_week_cell"];
    }
    
//    NSString *dayOfTheWeekString = [self stringForDayOfTheWeekOrdinal:(indexPath.row+1)];
//    cell.textLabel.text = dayOfTheWeekString;
    
    [cell setSelected:[((g5DayOfTheWeekCondition *)self.condition) containsDayOfTheWeek:(indexPath.row + 1)]];
    
    return cell;
}

#pragma mark - Helper

- (NSString *)stringForDayOfTheWeekOrdinal:(NSUInteger)ordinal {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = ordinal;
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorianCalendar dateFromComponents:dateComponents];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"EEEE";
    return [formatter stringFromDate:date];
}

@end
