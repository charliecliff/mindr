
@protocol HROCalendarRowDatasource <NSObject>

@required
- (NSMutableSet *)selectedDates;

@optional
- (UIFont *)font;
- (UIColor *)gridColor;
- (UIColor *)normalTextColor;
- (UIColor *)selectedTextColor;
- (UIColor *)normalBackgroundColor;
- (UIColor *)selectedBackgroundColor;

@end

@protocol HROCalendarRowDelegate <NSObject>

@required
- (void)didSelectDate:(NSDate *)date;
- (void)didDeSelectDate:(NSDate *)date;

@end