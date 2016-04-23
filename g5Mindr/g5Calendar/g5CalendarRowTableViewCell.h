//
//  g5CalendarRowTableViewCell.h
//  Pods
//
//  Created by Charles Cliff on 4/9/16.
//
//

#import <UIKit/UIKit.h>
#import "g5CalendarProtocols.h"

@interface g5CalendarRowTableViewCell : UITableViewCell

@property (nonatomic, strong) id<g5CalendarRowDelegate> delegate;
@property (nonatomic, strong) id<g5CalendarRowDatasource> datasource;

- (void)configureForDaysOfTheWeek;
- (void)configureForFirstDateOfTheWeek:(NSDate *)date fromCalendar:(NSCalendar *)calendar;

- (void)maskCellFromTop:(CGFloat)margin;

@end
