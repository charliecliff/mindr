//
//  MDRTimeTableViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 7/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRTimeTableViewController.h"
#import "MDRTimeTableViewCell.h"
#import "MDRTimeCondition.h"
#import "MDRTimeComponents.h"
#import "HROPickerTableView.h"

static NSString *const MDRTimeConditionCell = @"time_condition_cell";
static NSString *const MDRNewTimeConditionCell = @"add_new_time_condition_cell";

@interface MDRTimeTableViewController ()

@end

@implementation MDRTimeTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeCondition.times.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.timeCondition.times.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MDRNewTimeConditionCell forIndexPath:indexPath];
        return cell;
    }
    MDRTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MDRTimeConditionCell forIndexPath:indexPath];
    [cell configureForDate:[self.timeCondition.times objectAtIndex:indexPath.row]];
    [cell setTitleForIndexPath:indexPath];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.timeCondition.times.count)
        return 50;
    return 300;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.timeCondition.times.count) {
        MDRTime *newTime = [[MDRTime alloc] init];
        [self.timeCondition.times addObject:newTime];
        [self.tableView reloadData];
    }
}

@end
