//
//  g5DayOfTheWeekConditionTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface g5DayOfTheWeekConditionTableViewCell : UITableViewCell

@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UIImageView *checkMarkImageView;
@property(nonatomic, strong) IBOutlet UILabel *dayOfTheWeekLabel;

@end
