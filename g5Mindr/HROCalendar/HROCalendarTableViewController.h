
#import <UIKit/UIKit.h>

@interface HROCalendarTableViewController : UITableViewController

/**
 *  The calendar used to generate the view.
 *
 *  If not set, the default value is `[NSCalendar currentCalendar]`
 */
@property (nonatomic, strong) NSCalendar *calendar;

/**
 *  First date enabled in the calendar. If not set, the default value is the first day of the current month (based on `[NSDate date]`).
 *  You can pass every `NSDate`, if the firstDate is not the first day of its month, the previous days will be automatically disabled.
 */
@property (nonatomic, strong) NSDate *firstDate;

/**
 *  Last date enabled in the calendar. If not set, the default value is the first day of the month of `firstDate` + one year using `calendar` for calculation
 *  You can pass every `NSDate`, if the lastDate is not the last day of its month, the following days will be automatically disabled.
 */
@property (nonatomic, strong) NSDate *lastDate;

/**
 *
 */
@property (nonatomic, strong, readonly) NSMutableSet *selectedDates;

/**
 *
 */
@property (nonatomic, strong) UIColor *gridColor;

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
@property (nonatomic, strong) UIColor *normalBackgroundColor;

/**
 *
 */
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

/**
 *
 */
@property (nonatomic, strong) UIFont *calendarFont;

/**
 *
 */
- (instancetype)initWithSelectedDates:(NSArray *)dates;
- (instancetype)init NS_UNAVAILABLE;

@end
