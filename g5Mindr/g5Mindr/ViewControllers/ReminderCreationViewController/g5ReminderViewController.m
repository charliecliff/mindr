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

#import "AMWaveViewController.h"

@interface g5ReminderViewController () <g5ConditionDelegate, g5ConditionCellDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
{
    NSMutableArray *cells;
}

@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *backButtonBackground;

@end

@implementation g5ReminderViewController

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
    [self setUpNextButtonBackground];
    [self setUpBackButtonBackground];
    [self setUpCells];
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

- (void)setUpCells {
    cells = [[NSMutableArray alloc] init];
    
//    for ( int i = 0; i < 10; i++ ) {
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
        g5ConditionViewController *vc = [self viewControllerForCondition:selectedCondition];
        [self.navigationController pushViewController:vc animated:YES];
        [self.delegate didSelectConditionCell];
    }
}

#pragma mark - g5ConditionCell Delegate

- (void)g5Condition:(g5Condition *)condition didSetActive:(BOOL)active {
    condition.isActive = active;
    [self.reminder setCondition:condition];
    [self.tableView reloadData];
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
