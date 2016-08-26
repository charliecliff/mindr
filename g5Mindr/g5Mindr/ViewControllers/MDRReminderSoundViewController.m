#import "MDRReminderSoundViewController.h"
#import "g5DayOfTheWeekConditionTableViewCell.h"
#import "g5ReminderManager.h"

#import "g5ConfigAndMacros.h"

#import <AVFoundation/AVFoundation.h>

@interface MDRReminderSoundViewController () <UITableViewDataSource, UITableViewDelegate, HROBounceNavigationDelegate>

@property (strong, nonatomic) AVAudioPlayer *player;

@property (nonatomic, strong) IBOutlet UITableView *soundTableview;

@end

@implementation MDRReminderSoundViewController


#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}


#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = REMINDER_VIEW_CONTROLLER_SOUND;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    self.bounceNavigationController.delegate = self;
    [self.bounceNavigationController reload];
}

#pragma mark - Sound Helper

- (void)playSoundFileWithName:(NSString *)fileName {
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4r"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:pewPewURL error:nil];
    [self.player play];
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return REMINDER_SOUNDS.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= REMINDER_SOUNDS.count) {
        UITableViewCell *blankCell = [[UITableViewCell alloc] init];
        blankCell.backgroundColor = [UIColor clearColor];
        blankCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return blankCell;
    }
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    NSArray *topLevelObjects = [resourcesBundle loadNibNamed:@"g5DayOfTheWeekConditionTableViewCell" owner:self options:nil];
    g5DayOfTheWeekConditionTableViewCell *cell = [topLevelObjects objectAtIndex:0];
    
    
    BOOL shouldSelectCell = [self.reminder.sound isEqualToString:[REMINDER_SOUNDS objectAtIndex:indexPath.row]];
    
    cell.dayOfTheWeekLabel.text = [REMINDER_SOUNDS objectAtIndex:indexPath.row];

    [cell.checkMarkImageView setHidden:!shouldSelectCell];
    if (shouldSelectCell)
        [cell.dayOfTheWeekLabel setTextColor:GOLD_COLOR];
    else
        [cell.dayOfTheWeekLabel setTextColor:PERIWINKE_BLUE_COLOR];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= REMINDER_SOUNDS.count) return;
    self.reminder.sound = [REMINDER_SOUNDS objectAtIndex:indexPath.row];
    [self.soundTableview reloadData];
    [self playSoundFileWithName:self.reminder.sound];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == REMINDER_SOUNDS.count)
        return 200;
    return 60;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressRightButton {
    [[g5ReminderManager sharedManager] removeReminder:self.reminder];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didPressLeftButton {
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

@end
