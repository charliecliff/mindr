//
//  g5TimeConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimeConditionViewController.h"
#import "g5TimePicker.h"
#import "g5TimeCondition.h"

@interface g5TimeConditionViewController ()  <g5TimePickerDatasource, g5TimePickerDelegate>

@property(nonatomic, strong) IBOutlet g5TimePicker *picker;
@property(nonatomic, strong) IBOutlet UILabel *currentTimeLabel;

@property(nonatomic, strong) NSDate *date;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation g5TimeConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(g5Condition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (condition == nil) {
            self.condition = [[g5TimeCondition alloc] init];
        }
        self.date = [[self todayAtMidnight] dateByAddingTimeInterval:((g5TimeCondition *)self.condition).timeOfDayInSeconds];
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpDateFromatter];
    
    self.picker.g5PickerDelegate   = self;
    self.picker.g5PickerDatasource = self;
    
    [self reload];
}

- (void)reload {
    NSString *dateString = [self.dateFormatter stringFromDate:self.date];
    [self.currentTimeLabel setText:dateString];
    [self.picker configureForDate:self.date];
}

#pragma mark - Set Up

- (void)setUpDateFromatter {
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
}

#pragma mark - Helpers

- (NSDate *)todayAtMidnight {
    NSDate *const date = NSDate.date;
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:date];
    NSDate *const normalizedDate = [calendar dateFromComponents:components];
    return normalizedDate;
}

#pragma mark - g5TimePicker Datasource

- (UIColor *)textColor {
    return [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
}

- (UIFont *)textFont {
    return [UIFont systemFontOfSize:25.0];
}

#pragma mark - g5TimePicker Delegate

- (void)didSelectDate:(NSDate *)date {
    self.date = date;
    [((g5TimeCondition *)self.condition) setDate:self.date];
    [self reload];
}

@end
