
#import "HROCalendarTableViewController.h"
#import "HROCalendarRowTableViewCell.h"
#import "HROCalendarHeaderView.h"

#define HEADER_HEIGHT 30;

static NSString *const G5CalendarWeekCellIdentifier = @"G5CalendarWeekCellIdentifier";
static NSString *const G5CalendarHeaderCellIdentifier = @"G5CalendarHeaderCellIdentifier";

static const NSCalendarUnit kCalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

@interface HROCalendarTableViewController () <HROCalendarRowDatasource, HROCalendarRowDelegate> {
    CGFloat cellWidth;
}

@property (nonatomic) NSDate *firstDateMonth;
@property (nonatomic) NSDate *lastDateMonth;

@property (nonatomic, strong, readwrite) NSMutableSet *selectedDates;

@end

@implementation HROCalendarTableViewController

#pragma mark - Init

- (instancetype)initWithSelectedDates:(NSArray *)dates {
    self = [super init];
    if (self != nil) {
        if (dates != nil)
            self.selectedDates = [NSMutableSet setWithArray:dates];
        else
            self.selectedDates = [[NSMutableSet alloc] init];
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    self.view.backgroundColor = [UIColor clearColor];
}

#pragma mark - Set Up

- (void)setUpTableView {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setAllowsSelection:NO];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.tableView setShowsHorizontalScrollIndicator:NO];
    [self.tableView setBounces:NO];
    
    cellWidth = ( CGRectGetWidth(self.tableView.frame) - 12 ) / 7;
}

#pragma mark - Setters

- (void)setFirstDate:(NSDate *)firstDate {
    _firstDate = firstDate;
    
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD fromDate:self.firstDate];
    components.day = 1;
    self.firstDateMonth = [self.calendar dateFromComponents:components];
}

- (void)setLastDate:(NSDate *)lastDate {
    _lastDate = lastDate;
    
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD fromDate:self.lastDate];
    components.month++;
    components.day = 0;
    self.lastDateMonth = [self.calendar dateFromComponents:components];
}

#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDateMonth toDate:self.lastDateMonth options:0].month;
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfMonthsToOffsetFromFirstDateMonth = section;
    NSDate *firstDateInOffsetMonth = [self firstDayOfMonthForANumberOfMonthsRemovedFromFirstMonth:numberOfMonthsToOffsetFromFirstDateMonth];
    NSInteger numberOfWeeksInMonth = [self numberOfWeeksInMonthForDate:firstDateInOffsetMonth];
    return numberOfWeeksInMonth + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if ( indexPath.row == 0)
        cell = [self daysOfTheWeekCell];
    else
        cell = [self weekCellForRowAtIndexPath:indexPath];
    
    return cell;
}

- (UITableViewCell *)daysOfTheWeekCell {
    HROCalendarRowTableViewCell *cell = [self commmonInitForWeekRow];
    
    [cell configureForDaysOfTheWeek];
    
    return cell;
}

- (UITableViewCell *)weekCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HROCalendarRowTableViewCell *cell = [self commmonInitForWeekRow];
    
    NSDate *firstDayOfTheWeekForSection = [self firstDayOfTheWeekForIndexPath:indexPath];
    [cell configureForFirstDateOfTheWeek:firstDayOfTheWeekForSection fromCalendar:self.calendar];
    
    return cell;
}

- (HROCalendarRowTableViewCell *)commmonInitForWeekRow {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    HROCalendarRowTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:G5CalendarWeekCellIdentifier];
    if (!cell) {
        UINib *tableCell = [UINib nibWithNibName:@"HROCalendarRowTableViewCell" bundle:bundle] ;
        [self.tableView registerNib:tableCell forCellReuseIdentifier:@"HROCalendarRowTableViewCell"];
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"HROCalendarRowTableViewCell"];
    }
    cell.datasource = self;
    cell.delegate = self;
    return cell;
}

#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellWidth;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return cellWidth;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSArray *viewArray = [bundle loadNibNamed:@"HROCalendarHeaderView" owner:self options:nil];
    
    HROCalendarHeaderView *headerView = [viewArray objectAtIndex:0];
    headerView.datasource = self;
    
    NSDate *firstOfTheMonthForThisSection = [self firstOfMonthForSection:section];
    [headerView configureForFirstDayOfMonth:firstOfTheMonthForThisSection];
    return headerView;
}

#pragma mark - HROCalendarRowDelegate

- (void)didSelectDate:(NSDate *)date {
    [self.selectedDates addObject:date];
    [self.tableView reloadData];
}

- (void)didDeSelectDate:(NSDate *)date {
    [self.selectedDates removeObject:date];
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    for (HROCalendarRowTableViewCell *cell in self.tableView.visibleCells) {
        CGFloat hiddenFrameHeight = scrollView.contentOffset.y + cellWidth - cell.frame.origin.y;
        if (hiddenFrameHeight >= 0 || hiddenFrameHeight <= cell.frame.size.height) {
            [cell maskCellFromTop:hiddenFrameHeight];
        }
    }
}

#pragma mark - HROCalendarRowDatasource

- (NSMutableSet *)selectedDates {
    return _selectedDates;
}

- (UIFont *)font {
    return self.calendarFont;
}

- (UIColor *)gridColor {
    return _gridColor;
}

- (UIColor *)normalTextColor {
    return _normalTextColor;
}

- (UIColor *)selectedTextColor {
    return _selectedTextColor;
}

- (UIColor *)normalBackgroundColor {
    return _normalBackgroundColor;
}

- (UIColor *)selectedBackgroundColor {
    return _selectedBackgroundColor;
}

#pragma mark - Helper

- (NSDate *)firstOfMonthForSection:(NSInteger)section {
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;
    NSDate *outputDate = [self.calendar dateByAddingComponents:offset toDate:self.firstDateMonth options:0];
    return outputDate;
}

- (NSInteger)numberOfWeeksInMonthForDate:(NSDate *)date {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange weekRange = [calender rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitMonth forDate:date];
    NSInteger weeksCount = weekRange.length;
    return weeksCount;
}

- (NSDate *)firstDayOfMonthForANumberOfMonthsRemovedFromFirstMonth:(NSInteger)monthOffset {
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD fromDate:self.firstDateMonth];
    components.month = components.month + monthOffset;
    NSDate *firstDayOfNextMonth = [self.calendar dateFromComponents:components];
    return firstDayOfNextMonth;
}

- (NSDate *)firstDayOfTheWeekForIndexPath:(NSIndexPath *)indexPath {
    NSInteger adjustedRow = indexPath.row - 1;
    
    NSDate *firstDayOfTheMonth = [self firstOfMonthForSection:indexPath.section];
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitWeekOfMonth| NSCalendarUnitWeekday
                                                    fromDate:firstDayOfTheMonth];
    
    components.weekOfMonth = components.weekOfMonth + adjustedRow;
    if (adjustedRow != 0) {
        components.weekday = 1;
    }
    NSDate *firstDayOfTheWeek = [self.calendar dateFromComponents:components];
    return firstDayOfTheWeek;
}

@end
