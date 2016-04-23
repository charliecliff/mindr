//
//  g5ReminderViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderViewController.h"
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

@interface g5ReminderViewController () <g5ConditionDelegate, g5ConditionCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *conditionTableView;
@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *backButtonBackground;
@end

@implementation g5ReminderViewController

#pragma mark - Init

- (instancetype)initWithReminder:(g5Reminder *)reminder {
    self = [super initWithNibName:@"g5ReminderViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNextButtonBackground];
    [self setUpBackButtonBackground];
}

#pragma mark - Set Up

- (void)setUpNextButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.nextButtonBackground bounds].size.width, [self.nextButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.nextButtonBackground bounds]),CGRectGetMidY([self.nextButtonBackground bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.nextButtonBackground.frame.size.width, self.nextButtonBackground.frame.size.height) radius:self.nextButtonBackground.frame.size.width startAngle:3*M_PI_4 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[PRIMARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];

    [[self.nextButtonBackground layer] addSublayer:circleLayer];
}

- (void)setUpBackButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.backButtonBackground bounds].size.width, [self.backButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.backButtonBackground bounds]),CGRectGetMidY([self.backButtonBackground bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, self.backButtonBackground.frame.size.height) radius:self.backButtonBackground.frame.size.width startAngle:M_PI_2 endAngle:3*M_PI_2 clockwise:NO];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.backButtonBackground layer] addSublayer:circleLayer];
}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressNextButton:(id)sender {
    g5EmoticonSelectionViewController *vc = [[g5EmoticonSelectionViewController alloc] initWithReminder:self.reminder];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    g5ConditionTableViewCell *cell = [self.conditionTableView dequeueReusableCellWithIdentifier:@"g5ConditionTableViewCell"];
    if (!cell) {
        UINib *tableCell = [UINib nibWithNibName:@"g5ConditionTableViewCell" bundle:resourcesBundle] ;
        [self.conditionTableView registerNib:tableCell forCellReuseIdentifier:@"g5ConditionTableViewCell"];
        cell = [self.conditionTableView dequeueReusableCellWithIdentifier:@"g5ConditionTableViewCell"];
    }
    cell.delegate = self;
    
    g5Condition *selectedCondition = [self.reminder getConditionAtIndex:indexPath.row];
    if (selectedCondition.isActive) {
        [cell configureForActiveCondition:selectedCondition];
    }
    else {
        [cell configureForInActiveCondition:selectedCondition];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = self.reminder.conditionIDs.count;
    return rowCount;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    g5Condition *selectedCondition = [self.reminder getConditionAtIndex:selectedRow];
    if (selectedCondition.isActive) {
        g5ConditionViewController *vc = [self viewControllerForCondition:selectedCondition];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - g5ConditionCell Delegate

- (void)g5Condition:(g5Condition *)condition didSetActive:(BOOL)active {
    condition.isActive = active;
    [self.reminder setCondition:condition];
    [self.conditionTableView reloadData];
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
            vc = [[g5DateConditionViewController alloc] initWithDates:nil];
            break;
        
        case g5ConditionIDLocation:
            vc = [[g5LocationConditionViewController alloc] init];
            break;
        
        case g5ConditionIDTemperature:
            vc = [[g5TemperatureConditionViewController alloc] init];
            break;
            
        case g5ConditionIDTime:
            vc = [[g5TimeConditionViewController alloc] init];
            break;
        
        case g5ConditionIDWeather:
            vc = [[g5WeatherTypeConditionViewController alloc] init];
            break;
        
        default:
            break;
    }
    vc.delegate = self;
    vc.condition = condition;
    return vc;
}

@end
