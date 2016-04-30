//
//  g5TimePicker.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/26/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperaturePicker.h"

#define kRowsInPicker 10000

#define STARTING_HOUR_ROW_FOR_12 479
#define STARTING_MINUTE_ROW_FOR_00 480

#define WIDTH_FOR_DEGREE_COMPONENT 80

@interface g5TemperaturePicker ()

@property(nonatomic, strong) UILabel *colonLabel;

@property(nonatomic, strong) NSOrderedSet *prepostions;
@property(nonatomic, strong) NSOrderedSet *degrees;
@property(nonatomic, strong) NSOrderedSet *degreeUnits;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation g5TemperaturePicker

#pragma mark - Init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpComponentsRows];
//    [self setUpDateFormatter];
    
    self.showsSelectionIndicator = YES;
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectRow:STARTING_HOUR_ROW_FOR_12 inComponent:0 animated:NO];
    [self selectRow:STARTING_MINUTE_ROW_FOR_00 inComponent:1 animated:NO];
}

#pragma mark - View Life-Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    [self highlightSelectedElements];
    [self setUpSeparators];
}

#pragma mark - Set Up

- (void)setUpComponentsRows {
    self.degrees  = [[NSOrderedSet alloc] initWithObjects:
                     @"0\u00b0",
                     @"1\u00b0",
                     @"2\u00b0",
                     @"3\u00b0",
                     @"4\u00b0",
                     @"5\u00b0",
                     @"6\u00b0",
                     @"7\u00b0",
                     @"8\u00b0",
                     @"9\u00b0",
                     @"10\u00b0",
                     @"11\u00b0",
                     @"12\u00b0",
                     @"13\u00b0",
                     @"14\u00b0",
                     @"15\u00b0",
                     @"16\u00b0",
                     @"17\u00b0",
                     @"18\u00b0",
                     @"19\u00b0",
                     @"20\u00b0",
                     @"21\u00b0",
                     @"22\u00b0",
                     @"23\u00b0",
                     @"24\u00b0",
                     @"25\u00b0",
                     @"26\u00b0",
                     @"27\u00b0",
                     @"28\u00b0",
                     @"29\u00b0",
                     @"30\u00b0",
                     @"31\u00b0",
                     @"32\u00b0",
                     @"33\u00b0",
                     @"34\u00b0",
                     @"35\u00b0",
                     @"36\u00b0",
                     @"37\u00b0",
                     @"38\u00b0",
                     @"39\u00b0",
                     @"40\u00b0",
                     @"41\u00b0",
                     @"42\u00b0",
                     @"43\u00b0",
                     @"44\u00b0",
                     @"45\u00b0",
                     @"46\u00b0",
                     @"47\u00b0",
                     @"48\u00b0",
                     @"49\u00b0",
                     @"50\u00b0",
                     @"51\u00b0",
                     @"52\u00b0",
                     @"53\u00b0",
                     @"54\u00b0",
                     @"55\u00b0",
                     @"56\u00b0",
                     @"57\u00b0",
                     @"58\u00b0",
                     @"59\u00b0",
                     @"60\u00b0",
                     @"61\u00b0",
                     @"62\u00b0",
                     @"63\u00b0",
                     @"64\u00b0",
                     @"65\u00b0",
                     @"66\u00b0",
                     @"67\u00b0",
                     @"68\u00b0",
                     @"69\u00b0",
                     @"70\u00b0",
                     @"71\u00b0",
                     @"72\u00b0",
                     @"73\u00b0",
                     @"74\u00b0",
                     @"75\u00b0",
                     @"76\u00b0",
                     @"77\u00b0",
                     @"78\u00b0",
                     @"79\u00b0",
                     @"80\u00b0",
                     @"81\u00b0",
                     @"82\u00b0",
                     @"83\u00b0",
                     @"84\u00b0",
                     @"85\u00b0",
                     @"86\u00b0",
                     @"87\u00b0",
                     @"88\u00b0",
                     @"89\u00b0",
                     @"90\u00b0",
                     @"91\u00b0",
                     @"92\u00b0",
                     @"93\u00b0",
                     @"94\u00b0",
                     @"95\u00b0",
                     @"96\u00b0",
                     @"97\u00b0",
                     @"98\u00b0",
                     @"99\u00b0",
                     @"100\u00b0",
                     @"101\u00b0",
                     @"102\u00b0",
                     @"103\u00b0",
                     nil];
    self.degreeUnits = [[NSOrderedSet alloc] initWithObjects:@"C",@"F",nil];
    self.prepostions = [[NSOrderedSet alloc] initWithObjects:@"Above",@"Exactly",@"Below",nil];
}

//- (void)setUpColonLabel {
//    CGFloat widthOfHourColumn = [self rowSizeForComponent:0].width;
//    CGFloat heightOfFrame     = [self frame].size.height;
//
//    UIColor *selectedColor = [self.g5PickerDatasource textColor];
//
//    if (self.colonLabel != nil) {
//        [self.colonLabel removeFromSuperview];
//    }
//    self.colonLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthOfHourColumn - 40/2), (heightOfFrame - 40)/2, 40, 40)];
//    [self.colonLabel setBackgroundColor:[UIColor clearColor]];
//    [self.colonLabel setText:@" : "];
//    [self.colonLabel setTextColor:selectedColor];
//    [self.colonLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.colonLabel setFont:[UIFont systemFontOfSize:25.0]];
//
//    [self addSubview:self.colonLabel];
//}

- (void)setUpSeparators {
    if (self.subviews.count > 2) {
        UIView *view1 = [self.subviews objectAtIndex:1];
        UIView *view2 = [self.subviews objectAtIndex:2];
        
        [view1 removeFromSuperview];
        [view2 removeFromSuperview];
    }
}

//- (void)setUpDateFormatter {
//    self.dateFormatter = [[NSDateFormatter alloc] init];
//    [self.dateFormatter setDateFormat:@"hh:mm a"];
//    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//}

#pragma mark - Configure 

- (void)configureForDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    
    [self selectRow:STARTING_HOUR_ROW_FOR_12+hour inComponent:0 animated:NO];
    [self selectRow:STARTING_MINUTE_ROW_FOR_00+minute inComponent:1 animated:NO];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {      // Prepositions
        return self.prepostions.count;
    }
    else if (component == 1) { // Degrees
        return kRowsInPicker;
    }
    else if (component == 2) { // Degree Units
        return self.degreeUnits.count;
    }
    return 0;
}

#pragma mark - UIPickerViewDelegate

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:25.0]];
    
    [lblDate setTextColor:[self.g5PickerDatasource textColor]];
    [lblDate setBackgroundColor:[UIColor clearColor]];
    
    NSInteger offsetRow = row;
    if (component == 0)      // Prepositions
    {
        NSString *preposition = [self.prepostions objectAtIndex:offsetRow%[self.prepostions count]];
        lblDate.text = preposition;
        [lblDate setTextAlignment:NSTextAlignmentRight];
    }
    else if (component == 1) // Degrees
    {
        NSString *degree = [self.degrees objectAtIndex:offsetRow%[self.degrees count]];
        lblDate.text = degree;
        [lblDate setTextAlignment:NSTextAlignmentCenter];

    }
    else if (component == 2) // Degree Units
    {
        NSString *unit = [self.degreeUnits objectAtIndex:offsetRow%[self.degreeUnits count]];
        lblDate.text = unit;
        [lblDate setTextAlignment:NSTextAlignmentLeft];
    }
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self reloadAllComponents];
    [self highlightSelectedElements];
    
    if ([self.g5PickerDelegate respondsToSelector:@selector(didSelectDate:)]) {
        NSDate *selectedDate = [self generateDate];
        [self.g5PickerDelegate didSelectDate:selectedDate];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {      // Prepositions
        return (pickerView.frame.size.width - WIDTH_FOR_DEGREE_COMPONENT) / 2;
    }
    else if (component == 1) { // Degrees
        return WIDTH_FOR_DEGREE_COMPONENT;
    }
    else if (component == 2) { // Degree Units
        return (pickerView.frame.size.width - WIDTH_FOR_DEGREE_COMPONENT) / 2;
    }
    return 0;
}

#pragma mark - Helpers

- (void)highlightSelectedElements
{
    UIColor *selectedColor = [self.g5PickerDatasource textColor];
    
    for (int i = 0; i < 3; i++) {
        NSInteger row = [self selectedRowInComponent:i];
        UILabel *labelSelected = (UILabel*)[self viewForRow:row forComponent:i];
        [labelSelected setTextColor:selectedColor];
    }
}

- (NSDate *)generateDate
{
    NSInteger hourRow    = [self selectedRowInComponent:0];
    UILabel *hourLabel   = (UILabel*)[self viewForRow:hourRow forComponent:0];
    NSString *hourString = hourLabel.text;
    
    NSInteger minuteRow    = [self selectedRowInComponent:1];
    UILabel *minuteLabel   = (UILabel*)[self viewForRow:minuteRow forComponent:1];
    NSString *minuteString = minuteLabel.text;
    
    NSInteger meridianRow    = [self selectedRowInComponent:2];
    UILabel *meridianLabel   = (UILabel*)[self viewForRow:meridianRow forComponent:2];
    NSString *meridianString = meridianLabel.text;

    NSString *dateString = [NSString stringWithFormat:@"%@:%@ %@", hourString, minuteString, meridianString];
    NSDate *date = [self.dateFormatter dateFromString:dateString];
    return date;
}

@end
