//
//  g5ReminderListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderListViewController.h"
#import "g5ReminderManager.h"
#import "g5Reminder.h"
#import "g5ReminderViewController.h"
#import "g5ReminderTableViewCell.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderListViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *createReminderButtonBackgroundImage;
@property(nonatomic, strong) IBOutlet UITableView *reminderTableView;

@end

@implementation g5ReminderListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCreateReminderButtonBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.reminderTableView reloadData];
}

#pragma mark - Set Up

- (void)setUpCreateReminderButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.createReminderButtonBackgroundImage bounds].size.width, [self.createReminderButtonBackgroundImage bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.createReminderButtonBackgroundImage bounds]),CGRectGetMidY([self.createReminderButtonBackgroundImage bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.createReminderButtonBackgroundImage.frame.size.width/2, self.createReminderButtonBackgroundImage.frame.size.height) radius:self.createReminderButtonBackgroundImage.frame.size.height startAngle:0 endAngle:M_PI_2 clockwise:NO];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.createReminderButtonBackgroundImage layer] addSublayer:circleLayer];
}

#pragma mark - Actions

- (IBAction)didPressCreateNewReminderButton:(id)sender {
    g5ReminderViewController *vc = [[g5ReminderViewController alloc] init];
    vc.reminder = [[g5Reminder alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    g5ReminderTableViewCell *cell = [self.reminderTableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
    if (!cell) {
        UINib *tableCell = [UINib nibWithNibName:@"g5ReminderTableViewCell" bundle:resourcesBundle] ;
        [self.reminderTableView registerNib:tableCell forCellReuseIdentifier:@"g5ReminderTableViewCell"];
        cell = [self.reminderTableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger reminderCount = [g5ReminderManager sharedManager].reminderIDs.count;
    return reminderCount;
}

@end
