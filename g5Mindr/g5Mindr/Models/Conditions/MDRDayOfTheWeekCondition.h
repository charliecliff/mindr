#import "MDRCondition.h"
#define DAYS_OF_THE_WEEK_ARRAY [NSArray arrayWithObjects:@"Sunday",@"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday", nil]


@interface MDRDayOfTheWeekCondition : MDRCondition

@property(nonatomic, strong, readonly) NSString *dayOfTheWeekString;
@property(nonatomic, strong, readonly) NSMutableSet *daysOfTheWeek;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)setDayOfTheWeek:(NSInteger)weekday;
- (void)removeDayOfTheWeek:(NSInteger)weekday;
- (BOOL)containsDayOfTheWeek:(NSInteger)weekday;
- (NSString *)stringForWeekday:(NSInteger)dayOfTheWeekNumber;

@end
