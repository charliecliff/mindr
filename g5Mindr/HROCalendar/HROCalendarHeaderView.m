
#import "HROCalendarHeaderView.h"

@interface HROCalendarHeaderView ()

@property (nonatomic, strong) IBOutlet UILabel *monthLabel;
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet UIView *seperator;

@end

@implementation HROCalendarHeaderView

#pragma mark - Configure

- (void)configureForFirstDayOfMonth:(NSDate *)firstDayOftheMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat=@"MMMM";
    NSString * monthString = [[dateFormatter stringFromDate:firstDayOftheMonth] capitalizedString];
    [self.monthLabel setText:monthString];
    
    dateFormatter.dateFormat=@"YYYY";
    NSString * yearString = [[dateFormatter stringFromDate:firstDayOftheMonth] capitalizedString];
    [self.yearLabel setText:yearString];
}

#pragma mark - Setters

- (void)setDatasource:(id<HROCalendarRowDatasource>)datasource {
    _datasource = datasource;
    
    if ([self.datasource respondsToSelector:@selector(normalTextColor)]) {
        [self.monthLabel setTextColor:[self.datasource normalTextColor]];
        [self.yearLabel setTextColor:[self.datasource normalTextColor]];
    }
    
    if ([self.datasource respondsToSelector:@selector(font)]) {
        [self.monthLabel setFont:[self.datasource font]];
        [self.yearLabel setFont:[self.datasource font]];
    }
    
    if ([self.datasource respondsToSelector:@selector(gridColor)]) {
        [self.seperator setBackgroundColor:[self.datasource gridColor]];
    }
    
    if ([self.datasource respondsToSelector:@selector(normalBackgroundColor)]) {
        [self setBackgroundColor:[self.datasource normalBackgroundColor]];
    }
}

@end
