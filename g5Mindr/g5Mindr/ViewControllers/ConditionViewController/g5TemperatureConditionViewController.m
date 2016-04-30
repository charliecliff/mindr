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


@interface g5TemperatureConditionViewController () <g5TemperaturePickerDatasource, g5TemperaturePickerDelegate>

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

    self.picker.g5PickerDelegate   = self;
    self.picker.g5PickerDatasource = self;
}


#pragma mark - g5TemperaturePickerDatasource

- (UIColor *)textColor {
    return [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
}

- (UIFont *)textFont {
    return [UIFont systemFontOfSize:25.0];
}

#pragma mark - g5TemperaturePickerDelegate

- (void)didSelectDate:(NSDate *)date {
//    self.date = date;
//    [((g5TimeCondition *)self.condition) setDate:self.date];
//    [self reload];
}

@end
