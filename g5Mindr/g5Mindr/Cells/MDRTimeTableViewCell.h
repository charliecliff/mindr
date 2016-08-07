//
//  MDRTimeTableViewCell.h
//  g5Mindr
//
//  Created by Charles Cliff on 7/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDRTime;

@protocol MDRTimeTableViewCellDelegate <NSObject>

@required
- (void)didUpdateTime;

@end

@interface MDRTimeTableViewCell : UITableViewCell

@property(nonatomic, strong) id<MDRTimeTableViewCellDelegate> delegate;

- (void)configureForDate:(MDRTime *)time;

- (void)setTitleForIndexPath:(NSIndexPath *)indexPath;

@end
