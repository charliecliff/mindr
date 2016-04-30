//
//  g5ReminderListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderListViewController.h"
#import "g5ReminderManager.h"
#import "g5Reminder.h"

#import "g5ReminderViewController.h"
#import "g5ConditionListViewController.h"
#import "g5ConditionViewController.h"
#import "g5EmoticonSelectionViewController.h"
#import "g5ReminderExplanationViewController.h"

#import "g5ReminderTableViewCell.h"
#import "g5ConfigAndMacros.h"

#import "AMWaveTransition.h"
#import "IBCellFlipSegue.h"

#define coordinate 65
#define previous_button_bottom_constraint_on_screen 30

typedef enum {
    g5ViewReminderList = 0,
    g5ViewReminder,
    g5ViewCondition,
    g5ViewEmoticon,
    g5ViewExplanation
} g5ReminderState;

@interface g5ReminderListViewController () <UINavigationControllerDelegate, g5ConditionListViewControllerDelegate> {
    g5ReminderState state;
    NSMutableArray *cells;
    
    g5ConditionListViewController *reminderVC;
    g5EmoticonSelectionViewController *emoticonVC;
    g5ReminderExplanationViewController *detailVC;
}

@property(nonatomic, strong) IBOutlet UIView *previousButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *nextButtonContainerView;
@property(nonatomic, strong) IBOutlet UIView *cancelButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *cancelButtonContainerView;
@property(nonatomic, strong) IBOutlet UIImageView *centerButtonBackgroundImage;

@property(nonatomic, strong) IBOutlet UIView *contentView;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonHeightConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonBottomConstraint;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *previousButtonHeightConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *previousButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *nextButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *nextButtonTrailingConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *backButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *backButtonLeadingConstraint;

@property(nonatomic, strong) UITableViewController *reminderTableViewController;
@property(nonatomic, strong) UINavigationController *contentNavigationController;

@end

@implementation g5ReminderListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpCenterButtonBackgroundAsCircle];
    [self setUpBackButtonBackgroundAsCircle];
    [self setUpNextButtonBackgroundAsCircle];
    [self setUpPreviousButtonBackgroundAsCircle];
    [self setUpNavigationController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.contentNavigationController setDelegate:self];
    state = g5ViewReminderList;
}

#pragma mark - Set Up

- (void)setUpCenterButtonBackgroundAsCircle {
    self.centerButtonBackgroundImage.backgroundColor = PRIMARY_FILL_COLOR;
    self.centerButtonBackgroundImage.layer.cornerRadius = self.centerButtonBackgroundImage.frame.size.width / 2;
    self.centerButtonBackgroundImage.layer.masksToBounds = YES;
    self.centerButtonBackgroundImage.layer.borderColor = [PRIMARY_STROKE_COLOR CGColor];
    self.centerButtonBackgroundImage.layer.borderWidth = 4.0;
}

- (void)setUpNextButtonBackgroundAsCircle {
    self.nextButtonBackground.backgroundColor = PRIMARY_FILL_COLOR;
    self.nextButtonBackground.layer.cornerRadius = self.nextButtonBackground.frame.size.width / 2;
    self.nextButtonBackground.layer.masksToBounds = YES;
    self.nextButtonBackground.layer.borderColor = [PRIMARY_STROKE_COLOR CGColor];
    self.nextButtonBackground.layer.borderWidth = 4.0;
}

- (void)setUpBackButtonBackgroundAsCircle {
    self.cancelButtonBackground.backgroundColor = SECONDARY_FILL_COLOR;
    self.cancelButtonBackground.layer.cornerRadius = self.cancelButtonBackground.frame.size.width / 2;
    self.cancelButtonBackground.layer.masksToBounds = YES;
    self.cancelButtonBackground.layer.borderColor = [PRIMARY_STROKE_COLOR CGColor];
    self.cancelButtonBackground.layer.borderWidth = 4.0;
}

- (void)setUpPreviousButtonBackgroundAsCircle {
    self.previousButtonBackground.backgroundColor = SECONDARY_FILL_COLOR;
    self.previousButtonBackground.layer.cornerRadius = self.previousButtonBackground.frame.size.width / 2;
    self.previousButtonBackground.layer.masksToBounds = YES;
    self.previousButtonBackground.layer.borderColor = [PRIMARY_STROKE_COLOR CGColor];
    self.previousButtonBackground.layer.borderWidth = 4.0;
}

- (void)setUpNavigationController {
    self.reminderTableViewController = [[UITableViewController alloc] init];
    self.reminderTableViewController.view.backgroundColor = [UIColor clearColor];
    self.reminderTableViewController.tableView.backgroundColor = [UIColor clearColor];
    self.reminderTableViewController.tableView.dataSource = self;
    self.reminderTableViewController.tableView.delegate   = self;
    self.reminderTableViewController.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.reminderTableViewController.tableView.rowHeight = 80;

    self.contentNavigationController = [[UINavigationController alloc] initWithRootViewController:self.reminderTableViewController];
    self.contentNavigationController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentNavigationController.view.backgroundColor = [UIColor clearColor];
    self.contentNavigationController.view.tintColor = [UIColor clearColor];
    self.contentNavigationController.navigationBarHidden = YES;
    self.contentNavigationController.delegate = self;
    [self.contentView addSubview:self.contentNavigationController.view];
    
    [self setUpCells];
}

- (void)setUpCells {
    cells = [[NSMutableArray alloc] init];
    
    for (NSString *currentReminderUID in [g5ReminderManager sharedManager].reminderIDs) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        g5ReminderTableViewCell *cell = [self.reminderTableViewController.tableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        
        if (!cell) {
            UINib *tableCell = [UINib nibWithNibName:@"g5ReminderTableViewCell" bundle:resourcesBundle] ;
            [self.reminderTableViewController.tableView registerNib:tableCell forCellReuseIdentifier:@"g5ReminderTableViewCell"];
            cell = [self.reminderTableViewController.tableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        }
        
        g5Reminder *currentReminder = [[g5ReminderManager sharedManager] reminderForID:currentReminderUID];
        [cell configureWithReminder:currentReminder];
        
        [cells addObject:cell];
    }
}

#pragma mark - Actions

- (IBAction)didPressCreateNewReminderButton:(id)sender {
    g5Reminder *newReminder = [[g5ReminderManager sharedManager] newReminder];
    [self segueToConditionViewControllerWithReminder:newReminder];
}

- (IBAction)didPressPreviousButton:(id)sender {
    [self hidePreviousButtonWithCompletion:^{
        [self bounceCornerButtonOntoScreenWithCompletion:nil];
    }];
    [self.contentNavigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressNextButton:(id)sender {
    if (state == g5ViewCondition) {
        [self segueToEmoticonViewController];
    }
    else if (state == g5ViewEmoticon) {
        [self segueToExplanationViewController];
    }
    else if (state == g5ViewExplanation) {
        g5Reminder *reminderCurrentlyBeingBuilt = detailVC.reminder;
        [[g5ReminderManager sharedManager] addReminder:reminderCurrentlyBeingBuilt];
        
        [self setUpCells];
        [self.reminderTableViewController.tableView reloadData];
        
        [self hideCornerButtonsWithCompletion:^{
            [self bounceCenterButtonOntoScreenWithCompletion:nil];
        }];
        [self.contentNavigationController popToRootViewControllerAnimated:YES];
        
        state = g5ViewReminderList;
    }
}

- (IBAction)didPressCancelButton:(id)sender {
    [self hideCornerButtonsWithCompletion:^{
        [self bounceCenterButtonOntoScreenWithCompletion:nil];
    }];
    [self.contentNavigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Segues

- (void)segueToConditionViewControllerWithReminder:(g5Reminder *)reminder {
    [self hideCenterButtonWithCompletion:^{
        [self bounceCornerButtonOntoScreenWithCompletion:nil];
    }];
    
    reminderVC = [[g5ConditionListViewController alloc] initWithReminder:reminder];
    reminderVC.delegate = self;
    [self.contentNavigationController pushViewController:reminderVC animated:YES];
    
    state = g5ViewCondition;
}

- (void)segueToEmoticonViewController {
    g5Reminder *reminderCurrentlyBeingBuilt = reminderVC.reminder;
    emoticonVC = [[g5EmoticonSelectionViewController alloc] initWithReminder:reminderCurrentlyBeingBuilt];
    [self.contentNavigationController pushViewController:emoticonVC animated:YES];
    
    state = g5ViewEmoticon;
}

- (void)segueToExplanationViewController {
    g5Reminder *reminderCurrentlyBeingBuilt = reminderVC.reminder;
    detailVC = [[g5ReminderExplanationViewController alloc] initWithReminder:reminderCurrentlyBeingBuilt];
    [self.contentNavigationController pushViewController:detailVC animated:YES];
    
    state = g5ViewExplanation;
}

- (void)segueToReminderViewControllerWithReminder:(g5Reminder *)reminder {
    g5ReminderViewController *vc = [[g5ReminderViewController alloc] initWithReminder:reminder];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

#pragma mark - Button Animations

- (void)hideCornerButtonsWithCompletion:(void (^)(void))completion {
    self.nextButtonBottomConstraint.constant   = -2*coordinate;
    self.nextButtonTrailingConstraint.constant = -2*coordinate;
    
    self.backButtonBottomConstraint.constant   = -2*coordinate;
    self.backButtonLeadingConstraint.constant  = -2*coordinate;
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

- (void)hideCenterButtonWithCompletion:(void (^)(void))completion {
    self.centerButtonBottomConstraint.constant = -self.centerButtonHeightConstraint.constant;
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

- (void)hidePreviousButtonWithCompletion:(void (^)(void))completion {
    self.previousButtonBottomConstraint.constant = -self.previousButtonHeightConstraint.constant;
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

- (void)bounceCornerButtonOntoScreenWithCompletion:(void (^)(void))completion {
    self.nextButtonBottomConstraint.constant   = -coordinate;
    self.nextButtonTrailingConstraint.constant = -coordinate;

    self.backButtonBottomConstraint.constant   = -coordinate;
    self.backButtonLeadingConstraint.constant  = -coordinate;
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:20
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

- (void)bounceCenterButtonOntoScreenWithCompletion:(void (^)(void))completion {
    self.centerButtonBottomConstraint.constant = -55;
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:20
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

- (void)bouncePreviousButtonOntoScreenWithCompletion:(void (^)(void))completion {
    self.previousButtonBottomConstraint.constant = previous_button_bottom_constraint_on_screen;
    
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3
                          delay:0.0
         usingSpringWithDamping:0.5
          initialSpringVelocity:20
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         if (finished && completion) {
                             completion();
                         }
                     }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    g5Reminder *selectedReminder = [[g5ReminderManager sharedManager] reminderForIndex:indexPath.row];    
    [self segueToReminderViewControllerWithReminder:selectedReminder];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5ReminderTableViewCell *cell = [cells objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cells.count;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    
    if ([toVC isKindOfClass:[g5ConditionViewController class]]) {
        return nil;
    }

    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation];
    }
    return nil;
}

#pragma mark - g5ConditionListViewControllerDelegate

- (void)didSelectConditionCell {
    [self hideCornerButtonsWithCompletion:^{
        [self bouncePreviousButtonOntoScreenWithCompletion:nil];
    }];
}

@end
