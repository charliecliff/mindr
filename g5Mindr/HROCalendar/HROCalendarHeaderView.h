
#import <UIKit/UIKit.h>
#import "HROCalendarProtocols.h"

@interface HROCalendarHeaderView : UIView

@property (nonatomic, strong) id<HROCalendarRowDatasource> datasource;

- (void)configureForFirstDayOfMonth:(NSDate *)firstDayOftheMonth;

@end
