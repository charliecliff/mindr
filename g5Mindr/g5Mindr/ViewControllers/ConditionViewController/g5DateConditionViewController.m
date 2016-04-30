//
//  g5DateConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DateConditionViewController.h"
#import "g5CalendarTableViewController.h"
#import "g5DateCondition.h"

@interface g5DateConditionViewController ()

@property(nonatomic, strong) NSArray *selectedDates;
@property(nonatomic, strong) g5CalendarTableViewController *calendarVC;

@property(nonatomic, strong) IBOutlet UIView *calendarContainerView;

@end

@implementation g5DateConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(g5Condition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (self.condition == nil) {
            self.condition = [[g5DateCondition alloc] initWithDates:nil];
        }
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCalendarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSArray *dates = [self.calendarVC.selectedDates allObjects];
    ((g5DateCondition *)self.condition).dates = dates;
    [super viewWillDisappear:animated];
}

- (void)reload {
//    NSString *dateString = [self.dateFormatter stringFromDate:self.date];
//    [self.currentTimeLabel setText:dateString];
//    [self.picker configureForDate:self.date];
}

#pragma mark - Set Up

- (void)setUpCalendarView{
    
    self.calendarVC = [[g5CalendarTableViewController alloc] initWithSelectedDates:((g5DateCondition *)self.condition).dates];
    self.calendarVC.view.backgroundColor = [UIColor clearColor];
    
    self.calendarVC.calendar = [NSCalendar currentCalendar];
    self.calendarVC.firstDate = [NSDate date];

    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 3;
    offsetComponents.month = 0;
    self.calendarVC.lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
    self.calendarVC.gridColor               = [UIColor colorWithRed:57.0/255.0 green:85.0/255.0 blue:115.0/255.0 alpha:1];
    self.calendarVC.normalTextColor         = [UIColor whiteColor];;
    self.calendarVC.selectedTextColor       = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.calendarVC.normalBackgroundColor   = [UIColor clearColor];
    self.calendarVC.selectedBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.calendarVC.calendarFont = [UIFont systemFontOfSize:20];
    
    [self setUpCalendarViewConstraints];
}

- (void)setUpCalendarViewConstraints {
    [self.calendarContainerView addSubview:self.calendarVC.view];
    [self.calendarVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.calendarContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarVC.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.calendarContainerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
    [self.calendarContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarVC.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.calendarContainerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    
    [self.calendarContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarVC.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.calendarContainerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    
    [self.calendarContainerView addConstraint:[NSLayoutConstraint constraintWithItem:self.calendarVC.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.calendarContainerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
}

@end
