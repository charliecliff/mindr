//
//  g5CalendarProtocols.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/10/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

@protocol g5CalendarRowDatasource <NSObject>

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

@protocol g5CalendarRowDelegate <NSObject>

@required
- (void)didSelectDate:(NSDate *)date;
- (void)didDeSelectDate:(NSDate *)date;

@end