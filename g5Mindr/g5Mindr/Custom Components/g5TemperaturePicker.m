//
//  g5TimePicker.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/26/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperaturePicker.h"

#define kRowsInPicker 104

#define STARTING_ROW_FOR_DEGREE_COMPONENT 61
#define STARTING_ROW_FOR_COMPARISON_COMPONENT 480
#define STARTING_ROW_FOR_UNIT_COMPONENT 480

#define WIDTH_FOR_DEGREE_COMPONENT 80

@interface g5TemperaturePicker () {
    CGFloat fuckOff;
}

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
    self.showsSelectionIndicator = YES;
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectRow:STARTING_ROW_FOR_DEGREE_COMPONENT inComponent:1 animated:NO];
    
    
    fuckOff = 0;
}

#pragma mark - View Life-Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
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

- (void)setUpSeparators {
    if (self.subviews.count > 2) {
        UIView *view1 = [self.subviews objectAtIndex:1];
        UIView *view2 = [self.subviews objectAtIndex:2];
        
        [view1 removeFromSuperview];
        [view2 removeFromSuperview];
    }
}

#pragma mark - Configure 

- (void)configureForTemperature:(NSNumber *)temperature forComparison:(NSComparisonResult)comparison forUnit:(g5TemperatureUnit)unit {
    
    //  1. Comparison Component
    if (comparison == NSOrderedSame) {
        [self selectRow:1 inComponent:0 animated:NO];
    }
    else if (comparison == NSOrderedAscending) {
        [self selectRow:0 inComponent:0 animated:NO];
    }
    else if (comparison == NSOrderedDescending) {
        [self selectRow:2 inComponent:0 animated:NO];
    }
    
    //  2. Degree Component
    [self selectRow:STARTING_ROW_FOR_DEGREE_COMPONENT + [temperature integerValue] inComponent:1 animated:NO];
    
    //  3. Unit Component
    if (unit == g5TemperatureCelsius) {
        [self selectRow:0 inComponent:2 animated:NO];
    }
    else if (unit == g5TemperatureFahrenheit) {
        [self selectRow:1 inComponent:2 animated:NO];
    }
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
    
    if (component == 1) {
        //    CGRect theApparentRect = [view convertRect: theCell.bounds toView:pickerView];
        NSLog(@"Row %ld", (long)row);
        //    NSLog(@"Component %ld", (long)component);
        NSLog(@"Selected Row %ld", (long)[self selectedRowInComponent:1]);
        NSLog(@"Normalized Row %ld", (long)([self selectedRowInComponent:1] - row) + 2);
        
        NSLog(@"%ld", (long)[self viewForRow:row forComponent:component].frame.origin.y);
    }
    if (fuckOff != [self selectedRowInComponent:1]) {
        fuckOff = [self selectedRowInComponent:1];
//        [self reloadAllComponents];
    }

//    UIView [self viewForRow:row forComponent:component];
    
    CGFloat normalizedRow = [self selectedRowInComponent:1] - row;
    
    UILabel *lblDate = [[UILabel alloc] init];
    [lblDate setFont:[UIFont systemFontOfSize:25.0]];
    
    [lblDate setTextColor:[self.g5PickerDatasource textColor]];
    [lblDate setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:50*normalizedRow alpha:1]];
    
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
    
    //  1. Comparison
    NSInteger comparisonRow    = [self selectedRowInComponent:0];
    UILabel *label1   = (UILabel*)[self viewForRow:comparisonRow forComponent:0];
    NSString *comparisonString = label1.text;
    
    NSComparisonResult comparison = NSOrderedSame;;
    if ([comparisonString isEqualToString:@"Above"]) {
        comparison = NSOrderedAscending;
    }
    else if ([comparisonString isEqualToString:@"Exactly"]) {
        comparison = NSOrderedSame;
    }
    else if ([comparisonString isEqualToString:@"Below"]) {
        comparison = NSOrderedDescending;
    }
    
    //  2. Temperature
    NSInteger temperatureRow    = [self selectedRowInComponent:1];
    UILabel *label2   = (UILabel*)[self viewForRow:temperatureRow forComponent:1];
    NSInteger temperature = [label2.text integerValue];
    
    //  3. Units
    NSInteger unitRow    = [self selectedRowInComponent:2];
    UILabel *label3   = (UILabel*)[self viewForRow:unitRow forComponent:2];
    NSString *unitString = label3.text;
    
    g5TemperatureUnit unit = g5TemperatureFahrenheit;;
    if ([unitString isEqualToString:@"F"]) {
        unit = g5TemperatureFahrenheit;
    }
    else if ([unitString isEqualToString:@"C"]) {
        unit = g5TemperatureCelsius;
    }
    
    //  4. Delegate Method
    [self.g5PickerDelegate didSelectTemperature:temperature withComparionResult:comparison withUnit:unit];
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

@end
