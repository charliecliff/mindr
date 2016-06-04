//
//  g5TemperatureConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TemperatureConditionViewController.h"
#import "g5TemperaturePicker.h"
#import "g5TemperatureCondition.h"
#import "HROTemperatureComponents.h"

@interface g5TemperatureConditionViewController () <g5TemperaturePickerDatasource, g5TemperaturePickerDelegate>

@property(nonatomic, strong) IBOutlet UILabel *currentTemperatureLabel;
@property(nonatomic, strong) IBOutlet g5TemperaturePicker *picker;

@end

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
    self.navigationItem.title = @"Temperature";

    self.picker.g5PickerDelegate   = self;
    self.picker.g5PickerDatasource = self;

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
    NSString *temperatureLabelString;
    if (((g5TemperatureCondition *)self.condition).temperatureunit == g5TemperatureFahrenheit) {
        temperatureLabelString = [NSString stringWithFormat:@"%@\u00b0 %@",((g5TemperatureCondition *)self.condition).temperature, @"F"];
    }
    else if (((g5TemperatureCondition *)self.condition).temperatureunit == g5TemperatureCelsius) {
        temperatureLabelString = [NSString stringWithFormat:@"%@\u00b0 %@",((g5TemperatureCondition *)self.condition).temperature, @"C"];
    }
    
    [self.currentTemperatureLabel setText:temperatureLabelString];
    [self.picker configureForTemperature:((g5TemperatureCondition *)self.condition).temperature
                           forComparison:((g5TemperatureCondition *)self.condition).temperatureComparisonType
                                 forUnit:((g5TemperatureCondition *)self.condition).temperatureunit];
}

#pragma mark -  HROPickerDataSource

- (NSOrderedSet *)componentsForPickerView:(HROPickerTableView *)pickerTable {
    if ([pickerTable isEqual:self.degreeView]) {
        return [HROTemperatureComponents degrees];
    }
    else if ([pickerTable isEqual:self.unitView]) {
        return [HROTemperatureComponents degreeUnits];
    }
    else if ([pickerTable isEqual:self.prepositionView]) {
        return [HROTemperatureComponents prepostions];
    }
    return nil;
}

#pragma mark - g5TemperaturePickerDatasource

- (UIColor *)textColor {
    return [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
}

- (UIFont *)textFont {
    return [UIFont systemFontOfSize:25.0];
}

#pragma mark - g5TemperaturePickerDelegate

- (void)didSelectTemperature:(NSInteger)temperature withComparionResult:(NSComparisonResult)comparison withUnit:(g5TemperatureUnit)unit {
    
    ((g5TemperatureCondition *)self.condition).temperature = [NSNumber numberWithInteger:temperature];
    ((g5TemperatureCondition *)self.condition).temperatureComparisonType = comparison;
    ((g5TemperatureCondition *)self.condition).temperatureunit = unit;
    
    [self reload];
}

@end
