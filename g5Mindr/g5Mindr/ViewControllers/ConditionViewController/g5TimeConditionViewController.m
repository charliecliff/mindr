//
//  g5TimeConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimeConditionViewController.h"
#import "g5TimeCondition.h"
#import "HROPickerTableView.h"
#import "MNDRTimeComponents.h"

@interface g5TimeConditionViewController ()  <HROPickerDataSource, HROPickerDelegate>

@property(nonatomic, strong) IBOutlet HROPickerTableView *hourPicker;
@property(nonatomic, strong) IBOutlet HROPickerTableView *minutePicker;
@property(nonatomic, strong) IBOutlet HROPickerTableView *meridianPicker;

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
    self.navigationItem.title = @"Time";
    self.navigationItem.hidesBackButton = YES;
    
    self.hourPicker.selectedTextColor = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.hourPicker.normalTextColor   = [UIColor colorWithRed:57.0/255.0 green:86.0/255.0 blue:115.0/255.0 alpha:1];
    
    self.minutePicker.selectedTextColor = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.minutePicker.normalTextColor   = [UIColor colorWithRed:57.0/255.0 green:86.0/255.0 blue:115.0/255.0 alpha:1];
    
    self.meridianPicker.selectedTextColor = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.meridianPicker.normalTextColor   = [UIColor colorWithRed:57.0/255.0 green:86.0/255.0 blue:115.0/255.0 alpha:1];
    
    [self setUpDateFromatter];        
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

#pragma mark -  HROPickerDataSource

- (NSOrderedSet *)componentsForPickerView:(HROPickerTableView *)pickerTable {
    if ([pickerTable isEqual:self.hourPicker]) {
        return [MNDRTimeComponents hours];
    }
    else if ([pickerTable isEqual:self.minutePicker]) {
        return [MNDRTimeComponents minutes];
    }
    else if ([pickerTable isEqual:self.meridianPicker]) {
        return [MNDRTimeComponents meridians];
    }
    return nil;
}

#pragma mark -  HROPickerDelegate

- (void)pickerView:(HROPickerTableView *)pickerTable didSelectItemAtRow:(NSInteger)row {
    if ([pickerTable isEqual:self.hourPicker]) {
//        NSString *selection = [[HROTemperatureComponents degrees] objectAtIndex:row];
//        NSNumber *newTemperature = [HROTemperatureComponents temperatureFromString:selection];
//        ((g5TemperatureCondition *)self.condition).temperature = newTemperature;
    }
    else if ([pickerTable isEqual:self.minutePicker]) {
//        NSString *selection = [[HROTemperatureComponents degreeUnits] objectAtIndex:row];
//        g5TemperatureUnit unit = [HROTemperatureComponents temperatureunitFromString:selection];
//        ((g5TemperatureCondition *)self.condition).temperatureunit = unit;
    }
    else if ([pickerTable isEqual:self.meridianPicker]) {
//        NSString *selection = [[HROTemperatureComponents prepostions] objectAtIndex:row];
//        NSComparisonResult selectedComparison = [HROTemperatureComponents comparisonResultFromString:selection];
//        ((g5TemperatureCondition *)self.condition).temperatureComparisonType = selectedComparison;
    }
}

@end
