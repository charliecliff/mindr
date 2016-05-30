//
//  g5ReminderListViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "HROBounceNavigationController.h"
#import "AMWaveTransition.h"

#define coordinate 65
#define previous_button_bottom_constraint_on_screen 30

@interface HROBounceNavigationController () <UINavigationControllerDelegate> {
    UIViewController *rootVC;
}

@property(nonatomic, strong) IBOutlet UIButton      *leftButton;
@property(nonatomic, strong) IBOutlet UIView        *leftButtonBackground;
@property(nonatomic, strong) IBOutlet UIImageView   *leftButtonOverlayImageView;

@property(nonatomic, strong) IBOutlet UIButton      *rightButton;
@property(nonatomic, strong) IBOutlet UIView        *rightButtonBackground;
@property(nonatomic, strong) IBOutlet UIImageView   *rightButtonOverlayImageView;

@property(nonatomic, strong) IBOutlet UIButton      *bounceButton;
@property(nonatomic, strong) IBOutlet UIView        *bounceButtonBackground;
@property(nonatomic, strong) IBOutlet UIView        *bounceButtonContainerView;

@property(nonatomic, strong) IBOutlet UIButton      *bottomButton;
@property(nonatomic, strong) IBOutlet UIImageView   *bottomButtonBackgroundImage;
@property(nonatomic, strong) IBOutlet UIImageView   *bottomButtonOverlayImageView;

@property(nonatomic, strong) IBOutlet UIView        *contentView;

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

@implementation HROBounceNavigationController

#pragma mark - Init

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController withDelegate:(id<HROBounceNavigationDelegate>)delegate withDatasource:(id<HROBounceNavigationDatasource>)datasource {
    NSBundle *bundle = [NSBundle bundleForClass:[HROBounceNavigationController class]];
    self = [super initWithNibName:@"HROBounceNavigationController" bundle:bundle];
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
    [self setUpNavigationController];
    [self reload];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setDelegate:self];
}

#pragma mark - Set Up

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


#pragma mark - Reload

- (void)reload {
    [self reloadBottomButtonBackgroundAsCircle];
    [self reloadRightButtonBackgroundAsCircle];
    [self reloadLeftButtonBackgroundAsCircle];
    [self reloadBounceButtonBackgroundAsCircle];
}

- (void)reloadBottomButtonBackgroundAsCircle {
    self.bottomButtonBackgroundImage.backgroundColor = [self.datasource bottomButtonFillColor];
    self.bottomButtonBackgroundImage.layer.cornerRadius = self.bottomButtonBackgroundImage.frame.size.width / 2;
    self.bottomButtonBackgroundImage.layer.masksToBounds = YES;
    self.bottomButtonBackgroundImage.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.bottomButtonBackgroundImage.layer.borderWidth = 4.0;
    
    if ([self.datasource respondsToSelector:@selector(bottomButtonImage)]) {
        [self.bottomButton setImage:[self.datasource bottomButtonImage] forState:UIControlStateNormal];
    }
}

- (void)reloadRightButtonBackgroundAsCircle {
    self.rightButtonBackground.backgroundColor = [self.datasource rightButtonFillColor];
    self.rightButtonBackground.layer.cornerRadius = self.rightButtonBackground.frame.size.width / 2;
    self.rightButtonBackground.layer.masksToBounds = YES;
    self.rightButtonBackground.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.rightButtonBackground.layer.borderWidth = 4.0;
    
    self.rightButtonOverlayImageView.layer.cornerRadius = self.rightButtonBackground.frame.size.width / 2;
    self.rightButtonOverlayImageView.layer.masksToBounds = YES;
    
    if ([self.datasource respondsToSelector:@selector(leftCornerButtonImage)]) {
        [self.rightButton setImage:[self.datasource leftCornerButtonImage] forState:UIControlStateNormal];
    }
}

- (void)reloadBounceButtonBackgroundAsCircle {
    self.bounceButtonBackground.backgroundColor = [self.datasource leftButtonFillColor];
    self.bounceButtonBackground.layer.cornerRadius = self.bounceButtonBackground.frame.size.width / 2;
    self.bounceButtonBackground.layer.masksToBounds = YES;
    self.bounceButtonBackground.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.bounceButtonBackground.layer.borderWidth = 4.0;
    
    if ([self.datasource respondsToSelector:@selector(bounceButtonImage)]) {
        [self.bounceButton setImage:[self.datasource bounceButtonImage] forState:UIControlStateNormal];
    }
}

- (void)reloadLeftButtonBackgroundAsCircle {
    self.leftButtonBackground.backgroundColor = [self.datasource bounceButtonFillColor];
    self.leftButtonBackground.layer.cornerRadius = self.leftButtonBackground.frame.size.width / 2;
    self.leftButtonBackground.layer.masksToBounds = YES;
    self.leftButtonBackground.layer.borderColor = [[self.datasource strokeColor] CGColor];
    self.leftButtonBackground.layer.borderWidth = 4.0;
    
    if ([self.datasource respondsToSelector:@selector(rightCornerButtonImage)]) {
        [self.leftButton setImage:[self.datasource rightCornerButtonImage] forState:UIControlStateNormal];
    }
}

#pragma mark - Setters

- (void)setLeftButtonEnabled:(BOOL)nextButtonEnabled {
    
}

- (void)setRightButtonEnabled:(BOOL)nextButtonEnabled {
    [self.rightButtonOverlayImageView setHidden:nextButtonEnabled];
}

- (void)setBottomButtonEnabled:(BOOL)nextButtonEnabled {
    
}

- (void)setBounceButtonEnabled:(BOOL)nextButtonEnabled {
    
}

#pragma mark - Actions

- (IBAction)didPressCreateNewReminderButton:(id)sender {
    [self.delegate didPressCenterButton];
    if ([self.delegate respondsToSelector:@selector(didPressBottomButton)]) {
        [self.delegate didPressBottomButton];
    }
}

- (IBAction)didPressPreviousButton:(id)sender {
    [self.delegate didPressPreviousButton];
    if ([self.delegate respondsToSelector:@selector(didPressLeftButton)]) {
        [self.delegate didPressLeftButton];
    }
}

- (IBAction)didPressNextButton:(id)sender {
    [self.delegate didPressNextButton];
    if ([self.delegate respondsToSelector:@selector(didPressRightButton)]) {
        [self.delegate didPressRightButton];
    }
}

- (IBAction)didPressCancelButton:(id)sender {
    [self.delegate didPressCancelButton];
    if ([self.delegate respondsToSelector:@selector(didPressBounceButton)]) {
        [self.delegate didPressBounceButton];
    }
}

#pragma mark - Button Animations

- (void)displayCornerButtons:(BOOL)corners bottomButton:(BOOL)bottom bounceButton:(BOOL)bounce withCompletion:(void (^)(void))completion {
    // Update Constraints
    if (corners) {      // Display Corners
        self.nextButtonBottomConstraint.constant   = -coordinate;
        self.nextButtonTrailingConstraint.constant = -coordinate;
        
        self.backButtonBottomConstraint.constant   = -coordinate;
        self.backButtonLeadingConstraint.constant  = -coordinate;
    }
    else {              // Hide Corners
        self.nextButtonBottomConstraint.constant   = -2*coordinate;
        self.nextButtonTrailingConstraint.constant = -2*coordinate;
        
        self.backButtonBottomConstraint.constant   = -2*coordinate;
        self.backButtonLeadingConstraint.constant  = -2*coordinate;
    }
    
    if (bottom) {       // Display Bottom
        self.centerButtonBottomConstraint.constant = -55;
    }
    else {              // Hide Bottom
        self.centerButtonBottomConstraint.constant = -self.centerButtonHeightConstraint.constant;
    }

    if (bounce) {       // Display Bounce
        self.previousButtonBottomConstraint.constant = previous_button_bottom_constraint_on_screen;
    }
    else {              // Hide Bounce
        self.previousButtonBottomConstraint.constant = -self.previousButtonHeightConstraint.constant;
    }
    
    // Animate
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





/*
- (void)hideCornerButtonsWithCompletion:(void (^)(void))completion {
    self.nextButtonBottomConstraint.constant   = -2*coordinate;
    self.nextButtonTrailingConstraint.constant = -2*coordinate;
    
    self.backButtonBottomConstraint.constant   = -2*coordinate;
    self.backButtonLeadingConstraint.constant  = -2*coordinate;
    

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
*/

@end
