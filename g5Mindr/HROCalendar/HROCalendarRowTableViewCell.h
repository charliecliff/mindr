
#import <UIKit/UIKit.h>
#import "HROCalendarProtocols.h"

@interface HROCalendarRowTableViewCell : UITableViewCell

@property (nonatomic, strong) id<HROCalendarRowDelegate> delegate;
@property (nonatomic, strong) id<HROCalendarRowDatasource> datasource;

- (void)configureForDaysOfTheWeek;
- (void)configureForFirstDateOfTheWeek:(NSDate *)date fromCalendar:(NSCalendar *)calendar;

- (void)maskCellFromTop:(CGFloat)margin;

@end
