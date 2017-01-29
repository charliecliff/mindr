#import "g5ConditionListViewController.h"
#import "MDREmoticonSelectionViewController.h"
#import "MDRTimeConditionViewController.h"
#import "g5DayOfTheWeekViewController.h"
#import "g5DateConditionViewController.h"
#import "g5TemperatureConditionViewController.h"
#import "g5WeatherTypeConditionViewController.h"
//#import "g5LocationConditionViewController.h"
#import "g5ConditionTableViewCell.h"
#import "g5ReminderManager.h"
#import "MDRMessageAndCopy.h"
#import "AMWaveViewController.h"

#import "MDRCondition.h"

static NSInteger const NumberOfTrailingConditionCells = 2;

@interface g5ConditionListViewController () <g5ConditionDelegate, g5ConditionCellDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate> {
    NSMutableArray *cells;
}

@property (nonatomic, strong) NSArray *arrayOfCells;

@end

@implementation g5ConditionListViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self) {
        self.reminder = reminder;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.navigationItem.title = CONDITION_LIST_VC_TITLE;
        self.navigationItem.hidesBackButton = YES;
        
        self.tableView.bounces          = YES;
        self.tableView.backgroundColor  = [UIColor clearColor];
        self.tableView.separatorStyle   = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView   = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        self.tableView.showsVerticalScrollIndicator = NO;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCells];
    [self.bounceNavigationController setShouldShowTrashCanOnBounceButton:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    self.bounceNavigationController.delegate = self;
}

- (void)reloadBounceButtons {
    if ([self.reminder hasActiveConditions])
        [self.bounceNavigationController setRightButtonEnabled:YES];
    else
        [self.bounceNavigationController setRightButtonEnabled:NO];
}

- (void)reloadConditionTable {
    if ([self.reminder hasActiveConditions])
        [self.bounceNavigationController setRightButtonEnabled:YES];
    else
        [self.bounceNavigationController setRightButtonEnabled:NO];
    [self.tableView reloadData];
}

#pragma mark - Set Up

- (void)setUpCells {
    cells = [[NSMutableArray alloc] init];
    
    for (NSString *currentConditionUID in self.reminder.conditionIDs) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        g5ConditionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ConditionTableViewCell"];
        if (!cell) {
            UINib *tableCell = [UINib nibWithNibName:@"g5ConditionTableViewCell" bundle:resourcesBundle] ;
            [self.tableView registerNib:tableCell forCellReuseIdentifier:@"g5ConditionTableViewCell"];
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"g5ConditionTableViewCell"];
        }
        cell.delegate = self;
        
        MDRCondition *currentCondition = [self.reminder.conditions objectForKey:currentConditionUID];
        [cell configureForCondition:currentCondition];
        [cells addObject:cell];
    }
    
    for (int i = 0; i < NumberOfTrailingConditionCells; i++) {
        UITableViewCell *cell   = [[UITableViewCell alloc] init];
        cell.backgroundColor    = [UIColor clearColor];
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        [cells addObject:cell];
    }
}

#pragma mark - g5ConditionViewController Factory

- (g5ConditionViewController *)viewControllerForCondition:(MDRCondition *)condition {
    g5ConditionViewController *vc;
    
    if ( [condition.type isEqualToString:g5DateType] ) {
        vc = [[g5DateConditionViewController alloc] initWithCondition:condition];
    }
    else if ( [condition.type isEqualToString:g5TimeType] ) {
        vc = [[MDRTimeConditionViewController alloc] initWithCondition:condition];
    }
    else if ( [condition.type isEqualToString:g5DayOfTheWeekType] ) {
        vc = [[g5DayOfTheWeekViewController alloc] initWithCondition:condition];
    }
//    else if ( [condition.type isEqualToString:g5LocationType] ) {
//        vc = [[g5LocationConditionViewController alloc] initWithCondition:condition];
//        ((g5LocationConditionViewController *)vc).regionBorderColor = [UIColor whiteColor];
//        ((g5LocationConditionViewController *)vc).normalTextColor = [UIColor whiteColor];
//        ((g5LocationConditionViewController *)vc).highlightedColor = [UIColor colorWithRed:92/255.0 green:122/255.0 blue:153/255.0 alpha:1];
//    }
    else if ( [condition.type isEqualToString:g5TemperatureType] ) {
        vc = [[g5TemperatureConditionViewController alloc] initWithCondition:condition];
    }
    else if ( [condition.type isEqualToString:g5WeatherType] ) {
        vc = [[g5WeatherTypeConditionViewController alloc] initWithCondition:condition];
    }
    else {
        assert(false);
    }
    vc.delegate = self;
    vc.condition = condition;
    vc.bounceNavigationController = self.bounceNavigationController;
    return vc;
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5ConditionTableViewCell *cell = [cells objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = cells.count;
    return rowCount;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger selectedRow = indexPath.row;
    
    if (selectedRow < cells.count - NumberOfTrailingConditionCells) {
        NSString *currentConditionID = [self.reminder.conditionIDs objectAtIndex:selectedRow];
        MDRCondition *selectedCondition = [self.reminder.conditions objectForKey:currentConditionID];

        if (selectedCondition.isActive) {
            [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:^{
                [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:YES withCompletion:nil];
            }];
            g5ConditionViewController *vc = [self viewControllerForCondition:selectedCondition];
            [self.navigationController pushViewController:vc animated:YES];
            [self.delegate didSelectConditionCell];
        }
        else {
            g5ConditionTableViewCell *cell = [cells objectAtIndex:indexPath.row];
            [self conditionCell:cell didSetActive:(!selectedCondition.isActive)];
            [self reloadBounceButtons];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return REMINDERS_VC_ROW_HEIGHT;
}

#pragma mark - g5ConditionCell Delegate

- (void)conditionCell:(g5ConditionTableViewCell *)cell didSetActive:(BOOL)active {
    cell.condition.isActive = active;
    [cell setConditionActive:cell.condition.isActive];
    [self reloadBounceButtons];
}

#pragma mark - g5ConditionViewController Delegate

- (void)didUpdateCondition:(MDRCondition *)condition {
    [self.reminder.conditions setObject:condition forKey:condition.type];
}

@end
