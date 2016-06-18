//
//  g5ReminderDetailButtonTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 5/8/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnSwitchView.h"

@class MDRReminder;

@protocol g5ReminderButtonCellDelegate <NSObject>

@required
- (void)didPressSwitchButton;
@end

@interface g5ReminderDetailButtonTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet OnSwitchView *onSwitch;

@property(nonatomic, strong) id<g5ReminderButtonCellDelegate> delegate;

- (void)configWithReminder:(MDRReminder *)reminder withDelegate:(id<g5ReminderButtonCellDelegate>)delegate;

@end
