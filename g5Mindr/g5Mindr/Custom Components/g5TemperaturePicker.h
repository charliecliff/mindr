//
//  g5TimePicker.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/26/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol g5TemperaturePickerDatasource <NSObject>

@required
- (UIColor *)textColor;
- (UIFont *)textFont;

@end

@protocol g5TemperaturePickerDelegate <NSObject>

@required
- (void)didSelectDate:(NSDate *)date;

@end

@interface g5TemperaturePicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) id<g5TemperaturePickerDatasource> g5PickerDatasource;
@property(nonatomic, strong) id<g5TemperaturePickerDelegate> g5PickerDelegate;

- (void)configureForDate:(NSDate *)date;

@end
