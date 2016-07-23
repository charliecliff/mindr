//
//  g5TimeConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRTimeConditionViewController.h"
#import "MDRTimeTableViewController.h"
#import "MDRTimeCondition.h"

static NSString *const MDRTimeTitle = @"TIME";
static NSString *const MDRTimeTableViewControllerSegue = @"time_condition_table_segue";

@implementation MDRTimeConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(MDRCondition *)condition {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MDRTimeCondition" bundle:bundle];
    self = [storyboard instantiateInitialViewController];
    if (self != nil) {
        if (condition == nil) self.condition = [[MDRTimeCondition alloc] init];
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = MDRTimeTitle;
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:MDRTimeTableViewControllerSegue]) {
        MDRTimeTableViewController *timeConditionTableViewController = (MDRTimeTableViewController *)segue.destinationViewController;
        timeConditionTableViewController.timeCondition = (MDRTimeCondition *)self.condition;
        [timeConditionTableViewController.tableView reloadData];
    }
}

@end
