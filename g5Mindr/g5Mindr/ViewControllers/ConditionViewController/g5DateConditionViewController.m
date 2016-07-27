//
//  g5DateConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DateConditionViewController.h"
#import "HROCalendarTableViewController.h"
#import "MDRDateCondition.h"
#import "g5ConfigAndMacros.h"

@interface g5DateConditionViewController ()

@property(nonatomic, strong) NSArray *selectedDates;
@property(nonatomic, strong) HROCalendarTableViewController *calendarVC;

@property(nonatomic, strong) IBOutlet UIView *calendarContainerView;

@end

@implementation g5DateConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(MDRCondition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (self.condition == nil) {
            self.condition = [[MDRDateCondition alloc] init];
        }
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Dates";
    self.navigationItem.hidesBackButton = YES;

    [self setUpCalendarView];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSMutableArray *dates = [NSMutableArray arrayWithArray:[self.calendarVC.selectedDates allObjects]];
    NSArray *sortedArrayOfDates = [dates sortedArrayUsingComparator: ^(NSDate *d1, NSDate *d2) {
        return [d1 compare:d2];
    }];
    ((MDRDateCondition *)self.condition).dates = [NSMutableArray arrayWithArray:sortedArrayOfDates];
    [super viewWillDisappear:animated];
}

#pragma mark - Set Up

- (void)setUpCalendarView {
    self.calendarVC = [[HROCalendarTableViewController alloc] initWithSelectedDates:((MDRDateCondition *)self.condition).dates];
    self.calendarVC.gridColor               = SLATE_BLUE_COLOR;
    self.calendarVC.weekdayTextColor        = PERIWINKE_BLUE_COLOR;
    self.calendarVC.normalTextColor         = [UIColor whiteColor];;
    self.calendarVC.selectedTextColor       = GOLD_COLOR;
    self.calendarVC.normalBackgroundColor   = [UIColor clearColor];
    self.calendarVC.selectedBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.calendarVC.calendar                = [NSCalendar currentCalendar];
    self.calendarVC.firstDate               = [NSDate date];
    self.calendarVC.calendarFont            = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:17.0f];


    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    offsetComponents.year = 3;
    offsetComponents.month = 0;
    self.calendarVC.lastDate = [[NSCalendar currentCalendar] dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
    
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
