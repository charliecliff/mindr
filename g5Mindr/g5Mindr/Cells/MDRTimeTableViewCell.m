//
//  MDRTimeTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 7/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRTimeTableViewCell.h"
#import "HROPickerTableView.h"
#import "MDRTimeComponents.h"
#import "MDRTimeCondition.h"
#import "g5ConfigAndMacros.h"

@interface MDRTimeTableViewCell ()  <HROPickerDataSource, HROPickerDelegate>

//PRIVATE
@property(nonatomic, strong) MDRTime *time;

//OUTLETS
@property(nonatomic, strong) IBOutlet HROPickerTableView *hourPicker;
@property(nonatomic, strong) IBOutlet HROPickerTableView *minutePicker;
@property(nonatomic, strong) IBOutlet HROPickerTableView *meridianPicker;
@property(nonatomic, strong) IBOutlet UILabel *timeLabel;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation MDRTimeTableViewCell

- (void)configureForDate:(MDRTime *)time {
    self.time = time;
    
    self.hourPicker.selectedTextColor     = GOLD_COLOR;
    self.hourPicker.normalTextColor       = SLATE_BLUE_COLOR;
    self.hourPicker.font                  = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    
    self.minutePicker.selectedTextColor   = GOLD_COLOR;
    self.minutePicker.normalTextColor     = SLATE_BLUE_COLOR;
    self.minutePicker.font                = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    
    self.meridianPicker.selectedTextColor = GOLD_COLOR;
    self.meridianPicker.normalTextColor   = SLATE_BLUE_COLOR;
    self.meridianPicker.font              = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    
    [self reloadTime];
    [self reloadTitleLabels];
}

- (void)setTitleForIndexPath:(NSIndexPath *)indexPath {
    self.titleLabel.text = [NSString stringWithFormat:@"Time %ld", (long)indexPath.row + 1];
}

#pragma mark - Reloading

- (void)reloadTime {
    NSInteger hour              = self.time.hour;
    NSInteger minute            = self.time.minute;
    MDRTimeMeridian meridian    = self.time.meridian;
    
    NSInteger indexForHour      = [MDRTimeComponents indexForHour:hour];
    NSInteger indexForMinute    = [MDRTimeComponents indexForMinute:minute];
    NSInteger indexForMeridian  = [MDRTimeComponents indexForMeridian:meridian];

    [self.hourPicker scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForHour inSection:0]];
    [self.minutePicker scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForMinute inSection:0]];
    [self.meridianPicker scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForMeridian inSection:0]];
}

- (void)reloadTitleLabels {
    self.timeLabel.text = [self.time description];
}

#pragma mark -  HROPickerDataSource

- (NSOrderedSet *)componentsForPickerView:(HROPickerTableView *)pickerTable {
    if ([pickerTable isEqual:self.hourPicker])
        return [MDRTimeComponents hours];
    else if ([pickerTable isEqual:self.minutePicker])
        return [MDRTimeComponents minutes];
    else if ([pickerTable isEqual:self.meridianPicker])
        return [MDRTimeComponents meridians];
    return nil;
}

#pragma mark -  HROPickerDelegate

- (void)pickerView:(HROPickerTableView *)pickerTable didSelectItemAtRow:(NSInteger)row {
    if ([pickerTable isEqual:self.hourPicker]) {
        NSString *hourSelection = [[MDRTimeComponents hours] objectAtIndex:row];
        NSInteger hour = [MDRTimeComponents hourFromHourString:hourSelection];
        self.time.hour = hour;
    }
    else if ([pickerTable isEqual:self.minutePicker]) {
        NSString *selection = [[MDRTimeComponents minutes] objectAtIndex:row];
        NSInteger minute = [MDRTimeComponents minuteFromString:selection];
        self.time.minute = minute;
    }
    else if ([pickerTable isEqual:self.meridianPicker]) {
        NSString *meridianSelection = [[MDRTimeComponents meridians] objectAtIndex:row];
        MDRTimeMeridian meridian = [MDRTimeComponents meridianFromMeridianString:meridianSelection];
        self.time.meridian = meridian;
    }
    [self reloadTitleLabels];
}

@end
