//
//  g5TemperatureConditionViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionViewController.h"
#import "HROPickerTableView.h"

@interface g5TemperatureConditionViewController : g5ConditionViewController <HROPickerDataSource>

@property(nonatomic, strong) IBOutlet HROPickerTableView *degreeView;
@property(nonatomic, strong) IBOutlet HROPickerTableView *unitView;
@property(nonatomic, strong) IBOutlet HROPickerTableView *prepositionView;

@end
