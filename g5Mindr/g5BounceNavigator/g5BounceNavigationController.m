//
//  g5ReminderListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5BounceNavigationController.h"
#import "g5ReminderManager.h"
#import "g5Reminder.h"

#import "g5ReminderViewController.h"
#import "g5ConditionListViewController.h"
#import "g5ConditionViewController.h"
#import "g5EmoticonSelectionViewController.h"
#import "g5ReminderExplanationViewController.h"

#import "g5ReminderTableViewCell.h"

#import "AMWaveTransition.h"
#import "IBCellFlipSegue.h"

#define coordinate 65
#define previous_button_bottom_constraint_on_screen 30

@interface g5BounceNavigationController () <UINavigationControllerDelegate> {
    UIViewController *rootVC;
}

@property(nonatomic, strong) IBOutlet UIView *previousButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *nextButtonContainerView;
@property(nonatomic, strong) IBOutlet UIImageView *nextButtonOverlayImageView;
@property(nonatomic, strong) IBOutlet UIView *cancelButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *cancelButtonContainerView;
@property(nonatomic, strong) IBOutlet UIImageView *centerButtonBackgroundImage;
@property(nonatomic, strong) IBOutlet UIView *contentView;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *previousButtonHeightConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *previousButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *nextButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *nextButtonTrailingConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *backButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *backButtonLeadingConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonHeightConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonBottomConstraint;

@property(nonatomic, strong, readwrite) UINavigationController *navigationController;

@end

@implementation g5BounceNavigationController

#pragma mark - Init

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController withDelegate:(id<g5BounceNavigationDelegate>)delegate withDatasource:(id<g5BounceNavigationDatasource>)datasource {
    NSBundle *bundle = [NSBundle bundleForClass:[g5BounceNavigationController class]];
    self = [super initWithNibName:@"g5BounceNavigationController" bundle:bundle];
    if (self != nil) {
        rootVC = rootViewController;
        self.delegate = delegate;
        self.datasource = datasource;
    }
    return self;
}

#pragma mark - View Life Cycle

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
    [self.navigationController setDelegate:self];
}

#pragma mark - Set Up

- (void)setUpCenterButtonBackgroundAsCircle {
    self.centerButtonBackgroundImage.backgroundColor = [self.datasource primaryFillColor];
    self.centerButtonBackgroundImage.layer.cornerRadius = self.centerButtonBackgroundImage.frame.size.width / 2;
    self.centerButtonBackgroundImage.layer.masksToBounds = YES;
    self.centerButtonBackgroundImage.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.centerButtonBackgroundImage.layer.borderWidth = 4.0;
}

- (void)setUpNextButtonBackgroundAsCircle {
    self.nextButtonBackground.backgroundColor = [self.datasource primaryFillColor];
    self.nextButtonBackground.layer.cornerRadius = self.nextButtonBackground.frame.size.width / 2;
    self.nextButtonBackground.layer.masksToBounds = YES;
    self.nextButtonBackground.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.nextButtonBackground.layer.borderWidth = 4.0;
    
    self.nextButtonOverlayImageView.layer.cornerRadius = self.nextButtonBackground.frame.size.width / 2;
    self.nextButtonOverlayImageView.layer.masksToBounds = YES;
}

- (void)setUpBackButtonBackgroundAsCircle {
    self.cancelButtonBackground.backgroundColor = [self.datasource secondaryFillColor];
    self.cancelButtonBackground.layer.cornerRadius = self.cancelButtonBackground.frame.size.width / 2;
    self.cancelButtonBackground.layer.masksToBounds = YES;
    self.cancelButtonBackground.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.cancelButtonBackground.layer.borderWidth = 4.0;
}

- (void)setUpPreviousButtonBackgroundAsCircle {
    self.previousButtonBackground.backgroundColor = [self.datasource secondaryFillColor];
    self.previousButtonBackground.layer.cornerRadius = self.previousButtonBackground.frame.size.width / 2;
    self.previousButtonBackground.layer.masksToBounds = YES;
    self.previousButtonBackground.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.previousButtonBackground.layer.borderWidth = 4.0;
}

- (void)setUpNavigationController {
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
    self.navigationController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.view.tintColor = [UIColor clearColor];
    self.navigationController.delegate = self;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-2,self.navigationController.navigationBar.frame.size.width, 2)];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    if ([self.datasource respondsToSelector:@selector(textColor)]) {
        [navBorder setBackgroundColor:[self.datasource textColor]];
    }
    [navBorder setBackgroundColor:[UIColor whiteColor]];
    if ([self.datasource respondsToSelector:@selector(borderColor)]) {
        [navBorder setBackgroundColor:[self.datasource borderColor]];
    }
    [self.navigationController.navigationBar addSubview:navBorder];

    
    [self.contentView addSubview:self.navigationController.view];
}

#pragma mark - Setters

- (void)setNextButtonEnabled:(BOOL)nextButtonEnabled {
    [self.nextButtonOverlayImageView setHidden:nextButtonEnabled];
}

#pragma mark - Actions

- (IBAction)didPressCreateNewReminderButton:(id)sender {
    [self.delegate didPressCenterButton];
}

- (IBAction)didPressPreviousButton:(id)sender {
    [self.delegate didPressPreviousButton];
}

- (IBAction)didPressNextButton:(id)sender {
    [self.delegate didPressNextButton];
}

- (IBAction)didPressCancelButton:(id)sender {
    [self.delegate didPressCancelButton];
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

- (void)displayCornerButtonsOntoScreenWithCompletion:(void (^)(void))completion {
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

- (void)displayCenterButtonOntoScreenWithCompletion:(void (^)(void))completion {
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

- (void)displayPreviousButtonOntoScreenWithCompletion:(void (^)(void))completion {
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

@end
