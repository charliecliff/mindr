//
//  HROPickerTableView.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/4/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HROPickerTableView;

@protocol HROPickerDataSource <NSObject>

@required
- (NSOrderedSet *)componentsForPickerView:(HROPickerTableView *)pickerTable;

@end

@protocol HROPickerDelegate <NSObject>

@required

@end

@interface HROPickerTableView : UITableView

@property(nonatomic, strong) IBOutlet id<HROPickerDataSource> pickerDatasource;
@property(nonatomic, strong) IBOutlet id<HROPickerDelegate> pickerDelegate;

/**
 *
 */
@property (nonatomic) BOOL shouldInterpolateColors;


/**
 *
 */
@property (nonatomic, strong) UIColor *normalTextColor;

/**
 *
 */
@property (nonatomic, strong) UIColor *selectedTextColor;


/**
 *
 */
@property (nonatomic, strong) UIFont *font;

/**
 *
 */
@property (nonatomic) NSTextAlignment textAlignment;

@end
