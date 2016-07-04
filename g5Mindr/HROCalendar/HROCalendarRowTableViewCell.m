
#import "HROCalendarRowTableViewCell.h"
#import "HROCalendarProtocols.h"
#import <QuartzCore/QuartzCore.h>

@interface HROCalendarRowTableViewCell () {
    NSDate *firstDateOfTheWeek;
    
    NSDate *sunday;
    NSDate *monday;
    NSDate *tuesday;
    NSDate *wednesday;
    NSDate *thursday;
    NSDate *friday;
    NSDate *saturday;
}

@property (nonatomic, strong) IBOutlet UIView *separatorOne;
@property (nonatomic, strong) IBOutlet UIView *separatorTwo;
@property (nonatomic, strong) IBOutlet UIView *separatorThree;
@property (nonatomic, strong) IBOutlet UIView *separatorFour;
@property (nonatomic, strong) IBOutlet UIView *separatorFive;
@property (nonatomic, strong) IBOutlet UIView *separatorSix;
@property (nonatomic, strong) IBOutlet UIView *separatorTop;
@property (nonatomic, strong) IBOutlet UIView *separatorBottom;

@property (nonatomic, strong) IBOutlet UILabel *sundayLabel;
@property (nonatomic, strong) IBOutlet UILabel *mondayLabel;
@property (nonatomic, strong) IBOutlet UILabel *tuesdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *wednesdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *thursdayLabel;
@property (nonatomic, strong) IBOutlet UILabel *fridayLabel;
@property (nonatomic, strong) IBOutlet UILabel *saturdayLabel;

@property (nonatomic, strong) IBOutlet UIButton *sundayButton;
@property (nonatomic, strong) IBOutlet UIButton *mondayButton;
@property (nonatomic, strong) IBOutlet UIButton *tuesdayButton;
@property (nonatomic, strong) IBOutlet UIButton *wednesdayButton;
@property (nonatomic, strong) IBOutlet UIButton *thursdayButton;
@property (nonatomic, strong) IBOutlet UIButton *fridayButton;
@property (nonatomic, strong) IBOutlet UIButton *saturdayButton;

@end

@implementation HROCalendarRowTableViewCell

#pragma mark - Setters

- (void)setDatasource:(id<HROCalendarRowDatasource>)datasource {
    _datasource = datasource;
    
    if ([self.datasource respondsToSelector:@selector(gridColor)]) {
        [self.separatorOne setBackgroundColor:[self.datasource gridColor]];
        [self.separatorTwo setBackgroundColor:[self.datasource gridColor]];
        [self.separatorThree setBackgroundColor:[self.datasource gridColor]];
        [self.separatorFour setBackgroundColor:[self.datasource gridColor]];
        [self.separatorFive setBackgroundColor:[self.datasource gridColor]];
        [self.separatorSix setBackgroundColor:[self.datasource gridColor]];
        [self.separatorTop setBackgroundColor:[self.datasource gridColor]];
        [self.separatorBottom setBackgroundColor:[self.datasource gridColor]];
    }
    
    if ([self.datasource respondsToSelector:@selector(font)]) {
        [self.sundayLabel setFont:[self.datasource font]];
        [self.mondayLabel setFont:[self.datasource font]];
        [self.tuesdayLabel setFont:[self.datasource font]];
        [self.wednesdayLabel setFont:[self.datasource font]];
        [self.thursdayLabel setFont:[self.datasource font]];
        [self.fridayLabel setFont:[self.datasource font]];
        [self.saturdayLabel setFont:[self.datasource font]];
    }
}

#pragma mark - Actions

- (IBAction)didPressSundayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:sunday]) {
        [self.delegate didDeSelectDate:sunday];
    }
    else {
        [self.delegate didSelectDate:sunday];
    }
}

- (IBAction)didPressMondayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:monday]) {
        [self.delegate didDeSelectDate:monday];
    }
    else {
        [self.delegate didSelectDate:monday];
    }
}

- (IBAction)didPressTuesdayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:tuesday]) {
        [self.delegate didDeSelectDate:tuesday];
    }
    else {
        [self.delegate didSelectDate:tuesday];
    }
}

- (IBAction)didPressWednesdayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:wednesday]) {
        [self.delegate didDeSelectDate:wednesday];
    }
    else {
        [self.delegate didSelectDate:wednesday];
    }
}

- (IBAction)didPressThursdayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:thursday]) {
        [self.delegate didDeSelectDate:thursday];
    }
    else {
        [self.delegate didSelectDate:thursday];
    }
}

- (IBAction)didPressFridayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:friday]) {
        [self.delegate didDeSelectDate:friday];
    }
    else {
        [self.delegate didSelectDate:friday];
    }
}

- (IBAction)didPressSaturdayButton:(id)sender {
    if ([[self.datasource selectedDates] containsObject:saturday]) {
        [self.delegate didDeSelectDate:saturday];
    }
    else {
        [self.delegate didSelectDate:saturday];
    }
}

#pragma mark - Cell Masking

- (void)maskCellFromTop:(CGFloat)margin {
    self.layer.mask = [self visibilityMaskWithLocation:margin/self.frame.size.height];
    self.layer.masksToBounds = YES;
}

- (CAGradientLayer *)visibilityMaskWithLocation:(CGFloat)location {
    CAGradientLayer *mask = [CAGradientLayer layer];
    mask.frame = self.bounds;
    mask.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:1 alpha:0] CGColor], (id)[[UIColor colorWithWhite:1 alpha:1] CGColor], nil];
    mask.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:location], [NSNumber numberWithFloat:location], nil];
    return mask;
}

#pragma mark - Configure

- (void)configureForDaysOfTheWeek {
    [self.sundayLabel setText:@"S"];
    [self.mondayLabel setText:@"M"];
    [self.tuesdayLabel setText:@"T"];
    [self.wednesdayLabel setText:@"W"];
    [self.thursdayLabel setText:@"T"];
    [self.fridayLabel setText:@"F"];
    [self.saturdayLabel setText:@"S"];
    
    [self.sundayButton setUserInteractionEnabled:NO];
    [self.mondayButton setUserInteractionEnabled:NO];
    [self.tuesdayButton setUserInteractionEnabled:NO];
    [self.wednesdayButton setUserInteractionEnabled:NO];
    [self.thursdayButton setUserInteractionEnabled:NO];
    [self.fridayButton setUserInteractionEnabled:NO];
    [self.saturdayButton setUserInteractionEnabled:NO];
    
    if ([self.datasource respondsToSelector:@selector(gridColor)]) {
        [self.sundayLabel setTextColor:[self.datasource gridColor]];
        [self.mondayLabel setTextColor:[self.datasource gridColor]];
        [self.tuesdayLabel setTextColor:[self.datasource gridColor]];
        [self.wednesdayLabel setTextColor:[self.datasource gridColor]];
        [self.thursdayLabel setTextColor:[self.datasource gridColor]];
        [self.fridayLabel setTextColor:[self.datasource gridColor]];
        [self.saturdayLabel setTextColor:[self.datasource gridColor]];
    }
    
    if ([self.datasource respondsToSelector:@selector(normalBackgroundColor)]) {
        [self.sundayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.mondayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.tuesdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.wednesdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.thursdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.fridayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.saturdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
    }
}

- (void)configureForFirstDateOfTheWeek:(NSDate *)date fromCalendar:(NSCalendar *)calendar {
    
    [self.sundayLabel setText:@""];
    [self.mondayLabel setText:@""];
    [self.tuesdayLabel setText:@""];
    [self.wednesdayLabel setText:@""];
    [self.thursdayLabel setText:@""];
    [self.fridayLabel setText:@""];
    [self.saturdayLabel setText:@""];
    
    [self.sundayButton setUserInteractionEnabled:NO];
    [self.mondayButton setUserInteractionEnabled:NO];
    [self.tuesdayButton setUserInteractionEnabled:NO];
    [self.wednesdayButton setUserInteractionEnabled:NO];
    [self.thursdayButton setUserInteractionEnabled:NO];
    [self.fridayButton setUserInteractionEnabled:NO];
    [self.saturdayButton setUserInteractionEnabled:NO];
    
    if ([self.datasource respondsToSelector:@selector(normalTextColor)]) {
        [self.sundayLabel setTextColor:[self.datasource normalTextColor]];
        [self.mondayLabel setTextColor:[self.datasource normalTextColor]];
        [self.tuesdayLabel setTextColor:[self.datasource normalTextColor]];
        [self.wednesdayLabel setTextColor:[self.datasource normalTextColor]];
        [self.thursdayLabel setTextColor:[self.datasource normalTextColor]];
        [self.fridayLabel setTextColor:[self.datasource normalTextColor]];
        [self.saturdayLabel setTextColor:[self.datasource normalTextColor]];
    }

    if ([self.datasource respondsToSelector:@selector(normalBackgroundColor)]) {
        [self.sundayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.mondayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.tuesdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.wednesdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.thursdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.fridayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
        [self.saturdayLabel setBackgroundColor:[self.datasource normalBackgroundColor]];
    }
    
    firstDateOfTheWeek = date;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d"];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitWeekOfMonth| NSCalendarUnitWeekday
                                               fromDate:firstDateOfTheWeek];
    
    while ( components.weekday < 8 ) {
        NSDate *newDate = [calendar dateFromComponents:components];
        NSDateComponents *newDateComponents = [calendar components:NSCalendarUnitMonth fromDate:newDate];
        if (newDateComponents.month == components.month) {
            switch (components.weekday) {
                case 1:
                    sunday = newDate;
                    [self.sundayLabel setText:[dateFormatter stringFromDate:sunday]];
                    [self.sundayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:sunday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.sundayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.sundayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                case 2:
                    monday = newDate;
                    [self.mondayLabel setText:[dateFormatter stringFromDate:monday]];
                    [self.mondayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:monday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.mondayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.mondayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                case 3:
                    tuesday = newDate;
                    [self.tuesdayLabel setText:[dateFormatter stringFromDate:tuesday]];
                    [self.tuesdayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:tuesday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.tuesdayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.tuesdayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                case 4:
                    wednesday = newDate;
                    [self.wednesdayLabel setText:[dateFormatter stringFromDate:wednesday]];
                    [self.wednesdayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:wednesday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.wednesdayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.wednesdayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                case 5:
                    thursday = newDate;
                    [self.thursdayLabel setText:[dateFormatter stringFromDate:thursday]];
                    [self.thursdayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:thursday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.thursdayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.thursdayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                case 6:
                    friday = newDate;
                    [self.fridayLabel setText:[dateFormatter stringFromDate:friday]];
                    [self.fridayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:friday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.fridayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.fridayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                case 7:
                    saturday = newDate;
                    [self.saturdayLabel setText:[dateFormatter stringFromDate:saturday]];
                    [self.saturdayButton setUserInteractionEnabled:YES];

                    if ([[self.datasource selectedDates] containsObject:saturday]) {
                        if ([self.datasource respondsToSelector:@selector(selectedTextColor)])
                            [self.saturdayLabel setTextColor:[self.datasource selectedTextColor]];
                        if ([self.datasource respondsToSelector:@selector(selectedBackgroundColor)])
                            [self.saturdayLabel setBackgroundColor:[self.datasource selectedBackgroundColor]];
                    }
                    break;
                default:
                    break;
            }
        }
        components.weekday++;
    }
}

@end
