//
//  g5ReminderViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderViewController.h"
#import "g5EditReminderConditionListViewController.h"
#import "g5ReminderDetailSectionTableViewCell.h"
#import "g5ReminderDetailButtonTableViewCell.h"
#import "g5ConfigAndMacros.h"

@interface g5ReminderViewController () <g5ReminderButtonCellDelegate>

@property(nonatomic, strong, readwrite) g5Reminder *reminder;
@property(nonatomic, strong, readwrite) NSMutableArray *cells;

@property(nonatomic, strong) IBOutlet UIButton *deleteButton;
@property(nonatomic, strong) IBOutlet UIView *deleteButtonBackgroundView;

@property(nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *innerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *emoticonImageView;

@property(nonatomic, strong) IBOutlet UILabel *emoticonLabel;
@property(nonatomic, strong) IBOutlet UILabel *explanationLabel;

@property(nonatomic, strong) IBOutlet UITableView *reminderDetailTableview;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;

@end

@implementation g5ReminderViewController

#pragma mark - Init

- (instancetype)initWithReminder:(g5Reminder *)reminder {
    self = [super init];
    if (self != nil) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCells];
    [self setUpDeleteButtonBackgroundAsCircle];
    [self setUpOuterRingWithColor:[UIColor whiteColor]];
    [self setUpInnerRingWithColor:PRIMARY_STROKE_COLOR];
    
    [self.emoticonImageView setImage:[UIImage imageNamed:self.reminder.emoticonUnicodeCharacter]];
    
    self.explanationLabel.text = self.reminder.shortExplanation;
    self.emoticonLabel.text = self.reminder.emoticonUnicodeCharacter;
    
    self.tableViewHeightConstraint.constant = 44 * 3;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bounceNavigationController hideCenterButtonWithCompletion:nil];
    [self.bounceNavigationController hideCornerButtonsWithCompletion:nil];
    [self.bounceNavigationController hidePreviousButtonWithCompletion:nil];
}

#pragma mark - Set Up

- (void)setUpDeleteButtonBackgroundAsCircle {
    self.deleteButtonBackgroundView.backgroundColor = DELETE_FILL_COLOR;
    self.deleteButtonBackgroundView.layer.cornerRadius = self.deleteButtonBackgroundView.frame.size.width / 2;
    self.deleteButtonBackgroundView.layer.masksToBounds = YES;
    self.deleteButtonBackgroundView.layer.borderColor = [PRIMARY_STROKE_COLOR CGColor];
    self.deleteButtonBackgroundView.layer.borderWidth = 4.0;
}

- (void)setUpOuterRingWithColor:(UIColor *)color {
    CGFloat radius = self.outerRingImageView.frame.size.width/2;
    CGPoint center = CGPointMake(self.outerRingImageView.frame.size.width, self.outerRingImageView.frame.size.height);
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.outerRingImageView bounds].size.width, [self.outerRingImageView bounds].size.height)];
    [circleLayer setPosition:CGPointMake(0,0)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:[color CGColor]];
    [circleLayer setLineWidth:0.0f];
    
    [[self.outerRingImageView layer] addSublayer:circleLayer];
}

- (void)setUpInnerRingWithColor:(UIColor *)color {
    CGFloat radius = self.innerRingImageView.frame.size.width/2;
    CGPoint center = CGPointMake(self.innerRingImageView.frame.size.width, self.innerRingImageView.frame.size.height);
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.innerRingImageView bounds].size.width, [self.innerRingImageView bounds].size.height)];
    [circleLayer setPosition:CGPointMake(0,0)];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setFillColor:[color CGColor]];
    [circleLayer setLineWidth:0.0f];
    
    [[self.innerRingImageView layer] addSublayer:circleLayer];
}

- (void)setUpCells {
    self.cells = [[NSMutableArray alloc] init];
    
    g5ReminderDetailSectionTableViewCell *cell1 = [self newBlankSectionCell];
    cell1.titleLabel.text = @"Title";
//    [self.cells addObject:cell1];
    
    g5ReminderDetailSectionTableViewCell *cell2 = [self newBlankSectionCell];
    cell2.titleLabel.text = @"Conditions";
    cell2.explanationLabel.text = self.reminder.conditionDescription;
    [self.cells addObject:cell2];

    g5ReminderDetailSectionTableViewCell *cell3 = [self newBlankSectionCell];
    cell3.titleLabel.text = @"Sound";
    cell3.explanationLabel.text = self.reminder.pushNotificationSoundFileName;
    [self.cells addObject:cell3];

    g5ReminderDetailButtonTableViewCell *cell4 = [self newBlankButtonCell];
    cell4.titleLabel.text = @"Icon-only Notification";
    [cell4 configWithReminder:self.reminder withDelegate:self];
    
    [self.cells addObject:cell4];
}

- (g5ReminderDetailSectionTableViewCell *)newBlankSectionCell {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"g5ReminderDetailSectionTableViewCell" owner:self options:nil];
    g5ReminderDetailSectionTableViewCell *cell = [nibObjects objectAtIndex:0];
    return cell;
}

- (g5ReminderDetailButtonTableViewCell *)newBlankButtonCell {
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"g5ReminderDetailButtonTableViewCell" owner:self options:nil];
    g5ReminderDetailButtonTableViewCell *cell = [nibObjects objectAtIndex:0];
    return cell;
}

#pragma mark - Refresh

- (void)refresh {

}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
//        
//    }];
}

#pragma mark - Segues

- (void)segueToConditionViewControllerWithReminder:(g5Reminder *)reminder {
    [self.bounceNavigationController hideCenterButtonWithCompletion:nil];
    [self.bounceNavigationController hideCornerButtonsWithCompletion:nil];
    [self.bounceNavigationController hidePreviousButtonWithCompletion:nil];
    
    g5EditReminderConditionListViewController *conditionListVC = [[g5EditReminderConditionListViewController alloc] initWithReminder:reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

#pragma mark - g5ReminderButtonCellDelegate

- (void)didPressSwitchButton {
    self.reminder.isIconOnlyNotification = !self.reminder.isIconOnlyNotification;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        [self segueToConditionViewControllerWithReminder:self.reminder];
    }
    else if ( indexPath.row == 1 ) {
        
    }
    else if ( indexPath.row == 2 ) {
        
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor yellowColor];
    return [self.cells objectAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
//    [self.bounceNavigationController setNextButtonEnabled:NO];
//    
//    [self.bounceNavigationController hideCenterButtonWithCompletion:^{
//        [self. bounceNavigationController displayCornerButtonsOntoScreenWithCompletion:nil];
//    }];
//    
//    g5Reminder *newReminder = [[g5ReminderManager sharedManager] newReminder];
//    [self segueToConditionViewControllerWithReminder:newReminder];
}

- (void)didPressPreviousButton {
    assert(false);
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
//    [self.bounceNavigationController hideCornerButtonsWithCompletion:^{
//        [self.bounceNavigationController displayCenterButtonOntoScreenWithCompletion:nil];
//    }];
//    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
