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

@end

@implementation g5TimeConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(g5Condition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (condition == nil) {
            self.condition = [[g5TimeCondition alloc] init];
        }
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
    
    [self reload];
}

- (void)reload {
    NSInteger hour              = ((g5TimeCondition *)self.condition).hour;
    NSInteger minute            = ((g5TimeCondition *)self.condition).minute;
    MDRTimeMeridian meridian    = ((g5TimeCondition *)self.condition).meridian;
    
    NSInteger indexForHour      = [MNDRTimeComponents indexForHour:hour];
    NSInteger indexForMinute    = [MNDRTimeComponents indexForMinute:minute];
    NSInteger indexForMeridian  = [MNDRTimeComponents indexForMeridian:meridian];
    
    [self.hourPicker scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForHour inSection:0]];
    [self.minutePicker scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForMinute inSection:0]];
    [self.meridianPicker scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForMeridian inSection:0]];
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
        NSString *hourSelection = [[MNDRTimeComponents hours] objectAtIndex:row];
        NSInteger hour = [MNDRTimeComponents hourFromHourString:hourSelection];
        ((g5TimeCondition *)self.condition).hour = hour;
    }
    else if ([pickerTable isEqual:self.minutePicker]) {
        NSString *selection = [[MNDRTimeComponents minutes] objectAtIndex:row];
        NSInteger minute = [MNDRTimeComponents minuteFromString:selection];
        ((g5TimeCondition *)self.condition).minute = minute;
    }
    else if ([pickerTable isEqual:self.meridianPicker]) {
        NSString *meridianSelection = [[MNDRTimeComponents meridians] objectAtIndex:row];
        MDRTimeMeridian meridian = [MNDRTimeComponents meridianFromMeridianString:meridianSelection];
        ((g5TimeCondition *)self.condition).meridian = meridian;
    }
}

@end
