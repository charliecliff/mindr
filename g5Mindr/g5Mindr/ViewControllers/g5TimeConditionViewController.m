//
//  g5TimeConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/24/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5TimeConditionViewController.h"
#import "g5TimePicker.h"

@interface g5TimeConditionViewController ()  <g5TimePickerDatasource, g5TimePickerDelegate>

@property(nonatomic, strong) IBOutlet g5TimePicker *picker;
@property(nonatomic, strong) IBOutlet UILabel *currentTimeLabel;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation g5TimeConditionViewController

#pragma mark - View LIfe-Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpDateFromatter];
    
    self.picker.g5PickerDatasource = self;
    self.picker.g5PickerDelegate   = self;
}

- (void)setUpDateFromatter
{
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"hh:mm a"];
    [self.dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
}

#pragma mark - g5TimePicker Datasource

- (UIColor *)textColor
{
    return [UIColor colorWithRed:255.0/255.0 green:209.0/255.0 blue:77.0/255.0 alpha:1];
}

- (UIFont *)textFont
{
    return [UIFont systemFontOfSize:25.0];
}

#pragma mark - g5TimePicker Delegate

- (void)didSelectDate:(NSDate *)date
{
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    [self.currentTimeLabel setText:dateString];
}

@end
