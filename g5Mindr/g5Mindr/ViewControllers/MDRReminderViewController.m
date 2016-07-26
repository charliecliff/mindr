//
//  g5ReminderViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/29/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRReminderViewController.h"
#import "g5EditReminderConditionListViewController.h"
#import "MDRReminderDetailTableViewCell.h"
#import "g5ReminderDetailButtonTableViewCell.h"
#import "g5ReminderManager.h"
#import "g5ConfigAndMacros.h"

static NSString *MDRReminderDetailCellIdentifier = @"reminder_detail_cell";


@implementation MDRReminderDetailTableViewController

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if ( indexPath.row == 0 ) {
        
    }
    else if ( indexPath.row == 1 ) {
        
    }
    else if ( indexPath.row == 2 ) {
        
    }
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDRReminderDetailTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MDRReminderDetailCellIdentifier];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


@end

@interface MDRReminderViewController ()

// PROTECTED
@property(nonatomic, strong, readwrite) MDRReminder *reminder;
@property(nonatomic, strong, readwrite) NSMutableArray *cells;

// OUTLETS
@property(nonatomic, strong) IBOutlet UILabel *emoticonLabel;
@property(nonatomic, strong) IBOutlet UILabel *explanationLabel;
@property(nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *innerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *emoticonImageView;

@end

@implementation MDRReminderViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self != nil) {
        self.reminder = reminder;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.navigationItem.title = @"Reminder";
        self.navigationItem.hidesBackButton = YES;
        [self setUpBackButton];
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.emoticonImageView setImage:[UIImage imageNamed:self.reminder.emoticonUnicodeCharacter]];
    self.explanationLabel.text = self.reminder.explanation;
    self.emoticonLabel.text = self.reminder.emoticonUnicodeCharacter;
    [self.bounceNavigationController setShouldShowTrashCanOnBounceButton:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:YES withCompletion:nil];
}

#pragma mark - Set Up

- (void)setUpBackButton {
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [backButton setImage:[UIImage imageNamed:@"button_back_grey"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pressBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backButtonView addSubview:backButton];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    
    self.navigationItem.leftBarButtonItem = barBtn;
}

#pragma mark - Actions

- (void)pressBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segues

- (void)segueToConditionViewControllerWithReminder:(MDRReminder *)reminder {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:nil];
    
    g5EditReminderConditionListViewController *conditionListVC = [[g5EditReminderConditionListViewController alloc] initWithReminder:reminder];
    conditionListVC.bounceNavigationController = self.bounceNavigationController;
    [self.bounceNavigationController.navigationController pushViewController:conditionListVC animated:YES];
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    [[g5ReminderManager sharedManager] removeReminder:self.reminder];
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
    assert(false);
}

@end
