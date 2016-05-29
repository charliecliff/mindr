//
//  g5DayOfTheWeekConditionTableViewCell.m
//  g5Mindr
//
//  Created by Charles Cliff on 5/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5DayOfTheWeekConditionTableViewCell.h"
#import "g5ConfigAndMacros.h"

@interface g5DayOfTheWeekConditionTableViewCell ()

@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UIImageView *checkMarkImageView;

@end

@implementation g5DayOfTheWeekConditionTableViewCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self.backgroundImageView setHidden:!self.selected];
    [self.checkMarkImageView setHidden:!self.selected];
    
    if (self.selected) {
        [self.dayOfTheWeekLabel setTextColor:[UIColor whiteColor]];
    }
    else {
        [self.dayOfTheWeekLabel setTextColor:SECONDARY_FILL_COLOR];
    }
}

@end
