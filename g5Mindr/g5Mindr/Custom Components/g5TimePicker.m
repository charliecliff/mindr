//
//  g5TimePicker.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/26/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimePicker.h"

#define kRowsInPicker 10000

#define STARTING_HOUR_ROW_FOR_12 479
#define STARTING_MINUTE_ROW_FOR_00 480

@interface g5TimePicker ()

@property(nonatomic, strong) UILabel *colonLabel;

@property(nonatomic, strong) NSOrderedSet *hours;
@property(nonatomic, strong) NSOrderedSet *minutes;
@property(nonatomic, strong) NSOrderedSet *meridian;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation g5TimePicker

#pragma mark - Init

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpComponentsRows];
    [self setUpDateFormatter];
    
    self.showsSelectionIndicator = YES;
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectRow:STARTING_HOUR_ROW_FOR_12 inComponent:0 animated:NO];
    [self selectRow:STARTING_MINUTE_ROW_FOR_00 inComponent:1 animated:NO];
}

#pragma mark - View Life-Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUpColonLabel];
    [self highlightSelectedElements];
    [self setUpSeparators];
}

#pragma mark - Set Up

- (void)setUpComponentsRows
{
    self.hours    = [[NSOrderedSet alloc] initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    self.minutes  = [[NSOrderedSet alloc] initWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    self.meridian = [[NSOrderedSet alloc] initWithObjects:@"AM",@"PM",nil];
}

- (void)setUpColonLabel
{
    CGFloat widthOfHourColumn = [self rowSizeForComponent:0].width;
    CGFloat heightOfFrame     = [self frame].size.height;

    UIColor *selectedColor = [self.g5PickerDatasource textColor];

    if (self.colonLabel != nil) {
        [self.colonLabel removeFromSuperview];
    }
    self.colonLabel = [[UILabel alloc] initWithFrame:CGRectMake((widthOfHourColumn - 40/2), (heightOfFrame - 40)/2, 40, 40)];
    [self.colonLabel setBackgroundColor:[UIColor clearColor]];
    [self.colonLabel setText:@" : "];
    [self.colonLabel setTextColor:selectedColor];
    [self.colonLabel setTextAlignment:NSTextAlignmentCenter];
    [self.colonLabel setFont:[UIFont systemFontOfSize:25.0]];

    [self addSubview:self.colonLabel];
}

- (void)setUpSeparators
{
    if (self.subviews.count > 2) {
        UIView *view1 = [self.subviews objectAtIndex:1];
        UIView *view2 = [self.subviews objectAtIndex:2];
        
        [view1 removeFromSuperview];
        [view2 removeFromSuperview];
    }
}

- (void)setUpDateFormatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
}

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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 2:
            return 2;
            break;
        default:
            return kRowsInPicker;
            break;
    }
}

#pragma mark - UIPickerViewDelegate

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:25.0]];
    
    [lblDate setTextColor:[UIColor whiteColor]];
    
    [lblDate setBackgroundColor:[UIColor clearColor]];
    [lblDate setTextAlignment:NSTextAlignmentCenter];
    
    NSInteger offsetRow = row;
    if (component == 0) // Hours
    {
        NSString *hour = [self.hours objectAtIndex:offsetRow%[self.hours count]];
        lblDate.text = hour;
    }
    else if (component == 1) // Minutes
    {
        NSString *minute = [self.minutes objectAtIndex:offsetRow%[self.minutes count]];
        lblDate.text = minute;
    }
    else if (component == 2) // Meridian
    {
        NSString *meridian = [self.meridian objectAtIndex:offsetRow%[self.meridian count]];
        lblDate.text = meridian;
    }
    return lblDate;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self reloadAllComponents];
    [self highlightSelectedElements];
    
    if ([self.g5PickerDelegate respondsToSelector:@selector(didSelectDate:)]) {
        NSDate *selectedDate = [self generateDate];
        [self.g5PickerDelegate didSelectDate:selectedDate];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
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
