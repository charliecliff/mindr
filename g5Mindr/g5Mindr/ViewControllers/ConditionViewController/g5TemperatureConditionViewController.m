//
//  g5TemperatureConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperatureConditionViewController.h"
#import "g5TemperatureCondition.h"
#import "MDRTemperatureComponents.h"

static NSString *const MDRTemperatureTitle = @"TEMPERATURE";

@implementation g5TemperatureConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(g5Condition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (condition == nil) {
            self.condition = [[g5TemperatureCondition alloc] init];
        }
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = MDRTemperatureTitle;
    self.navigationItem.hidesBackButton = YES;

    self.degreeView.selectedTextColor = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.degreeView.normalTextColor   = [UIColor colorWithRed:57.0/255.0 green:86.0/255.0 blue:115.0/255.0 alpha:1];

    self.unitView.selectedTextColor = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.unitView.normalTextColor   = [UIColor colorWithRed:57.0/255.0 green:86.0/255.0 blue:115.0/255.0 alpha:1];

    self.prepositionView.selectedTextColor = [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
    self.prepositionView.normalTextColor   = [UIColor colorWithRed:57.0/255.0 green:86.0/255.0 blue:115.0/255.0 alpha:1];
    self.prepositionView.textAlignment     = NSTextAlignmentLeft;
    
    [self reload];
}

- (void)reload {
    NSComparisonResult comparisonType  = ((g5TemperatureCondition *)self.condition).temperatureComparisonType;
    g5TemperatureUnit temperatureUnit  = ((g5TemperatureCondition *)self.condition).temperatureunit;
    NSNumber *temperature               = ((g5TemperatureCondition *)self.condition).temperature;
    
    NSInteger indexForComparisonType    = [MDRTemperatureComponents indexForComparisonResult:comparisonType];
    NSInteger indexForTemperatureUnit   = [MDRTemperatureComponents indexForTemperatureUnit:temperatureUnit];
    NSInteger indexForTemperature       = [MDRTemperatureComponents indexForTemperature:temperature];
    
    [self.prepositionView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForComparisonType inSection:0]];
    [self.unitView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForTemperatureUnit inSection:0]];
    [self.degreeView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexForTemperature inSection:0]];
}

#pragma mark -  HROPickerDataSource

- (NSOrderedSet *)componentsForPickerView:(HROPickerTableView *)pickerTable {
    if ([pickerTable isEqual:self.degreeView]) {
        return [MDRTemperatureComponents degrees];
    }
    else if ([pickerTable isEqual:self.unitView]) {
        return [MDRTemperatureComponents degreeUnits];
    }
    else if ([pickerTable isEqual:self.prepositionView]) {
        return [MDRTemperatureComponents prepostions];
    }
    return nil;
}

#pragma mark -  HROPickerDelegate

- (void)pickerView:(HROPickerTableView *)pickerTable didSelectItemAtRow:(NSInteger)row {
    if ([pickerTable isEqual:self.degreeView]) {
        NSString *selection = [[MDRTemperatureComponents degrees] objectAtIndex:row];
        NSNumber *newTemperature = [MDRTemperatureComponents temperatureFromString:selection];
        ((g5TemperatureCondition *)self.condition).temperature = newTemperature;
    }
    else if ([pickerTable isEqual:self.unitView]) {
        NSString *selection = [[MDRTemperatureComponents degreeUnits] objectAtIndex:row];
        g5TemperatureUnit unit = [MDRTemperatureComponents temperatureunitFromString:selection];
        ((g5TemperatureCondition *)self.condition).temperatureunit = unit;
    }
    else if ([pickerTable isEqual:self.prepositionView]) {
        NSString *selection = [[MDRTemperatureComponents prepostions] objectAtIndex:row];
        NSComparisonResult selectedComparison = [MDRTemperatureComponents comparisonResultFromString:selection];
        ((g5TemperatureCondition *)self.condition).temperatureComparisonType = selectedComparison;
    }
}

@end
