//
//  g5TimePicker.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/26/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol g5TimePickerDatasource <NSObject>

@required
- (UIColor *)textColor;
- (UIFont *)textFont;

@end

@protocol g5TimePickerDelegate <NSObject>

@required
- (void)didSelectDate:(NSDate *)date;

@end

@interface g5TimePicker : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property(nonatomic, strong) id<g5TimePickerDatasource> g5PickerDatasource;
@property(nonatomic, strong) id<g5TimePickerDelegate> g5PickerDelegate;

@end
