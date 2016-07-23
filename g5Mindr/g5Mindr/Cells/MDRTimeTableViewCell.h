//
//  MDRTimeTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 7/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRTime;

@interface MDRTimeTableViewCell : UITableViewCell

- (void)configureForDate:(MDRTime *)time;

@end
