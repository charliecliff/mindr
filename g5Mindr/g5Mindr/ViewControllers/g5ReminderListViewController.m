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
#import "g5ReminderTableViewCell.h"
#import "g5ConfigAndMacros.h"

#define coordinate 65

@interface g5ReminderListViewController () {
    NSMutableArray *cells;
}

@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *nextButtonContainerView;

@property(nonatomic, strong) IBOutlet UIView *backButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *backButtonContainerView;

@property(nonatomic, strong) IBOutlet UIImageView *centerButtonBackgroundImage;
@property(nonatomic, strong) IBOutlet UITableView *reminderTableView;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonHeightConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonBottomConstraint;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *nextButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *nextButtonTrailingConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *backButtonBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *backButtonLeadingConstraint;

@end

@implementation g5ReminderListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCenterButtonBackgroundAsCircle];
    [self setUpBackButtonBackgroundAsCircle];
    [self setUpNextButtonBackgroundAsCircle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpCells];
    [self.reminderTableView reloadData];
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
    
    self.backButtonBackground.backgroundColor = SECONDARY_FILL_COLOR;
    
    self.backButtonBackground.layer.cornerRadius = self.backButtonBackground.frame.size.width / 2;
    self.backButtonBackground.layer.masksToBounds = YES;
    self.backButtonBackground.layer.borderColor = [PRIMARY_STROKE_COLOR CGColor];
    self.backButtonBackground.layer.borderWidth = 4.0;
}

/*
- (void)setUpNextButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.nextButtonBackground.frame.size.width, self.nextButtonBackground.frame.size.height)
                                                        radius:self.nextButtonBackground.frame.size.width
                                                    startAngle:M_PI
                                                      endAngle:3*M_PI_2
                                                     clockwise:YES];
    CGPathRef cgPath = path.CGPath;
    CGMutablePathRef mutablePath = CGPathCreateMutableCopy(cgPath);
    CGPathAddLineToPoint( mutablePath, NULL, self.nextButtonBackground.frame.size.width, self.nextButtonBackground.frame.size.height );
    [circleLayer setPath:mutablePath];

    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.nextButtonBackground bounds].size.width, [self.nextButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.nextButtonBackground bounds]),CGRectGetMidY([self.nextButtonBackground bounds]))];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[PRIMARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.nextButtonBackground layer] addSublayer:circleLayer];
}

- (void)setUpBackButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, self.nextButtonBackground.frame.size.height)
                                                        radius:self.nextButtonBackground.frame.size.width
                                                    startAngle:3*M_PI_2
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    CGPathRef cgPath = path.CGPath;
    CGMutablePathRef mutablePath = CGPathCreateMutableCopy(cgPath);
    CGPathAddLineToPoint( mutablePath, NULL, 0, self.nextButtonBackground.frame.size.height );
    [circleLayer setPath:mutablePath];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.backButtonBackground bounds].size.width, [self.backButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.backButtonBackground bounds]),CGRectGetMidY([self.backButtonBackground bounds]))];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.backButtonBackground layer] addSublayer:circleLayer];
}
 
 - (void)setUpButtonToRotateOntoScreen {
 [self.nextButtonContainerView setTransform:CGAffineTransformRotate(self.nextButtonContainerView.transform, M_PI_2)];
 [self.backButtonContainerView setTransform:CGAffineTransformRotate(self.backButtonContainerView.transform, -M_PI_2)];
 }

- (void)setUpCreateReminderButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.createReminderButtonBackgroundImage bounds].size.width, [self.createReminderButtonBackgroundImage bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.createReminderButtonBackgroundImage bounds]),CGRectGetMidY([self.createReminderButtonBackgroundImage bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.createReminderButtonBackgroundImage.frame.size.width/2, self.createReminderButtonBackgroundImage.frame.size.height) radius:self.createReminderButtonBackgroundImage.frame.size.height startAngle:0 endAngle:M_PI_2 clockwise:NO];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.createReminderButtonBackgroundImage layer] addSublayer:circleLayer];
}
*/
- (void)setUpCells {
    cells = [[NSMutableArray alloc] init];
    
    for (NSString *currentReminderUID in [g5ReminderManager sharedManager].reminderIDs) {
        NSBundle *resourcesBundle = [NSBundle mainBundle];
        g5ReminderTableViewCell *cell = [self.reminderTableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        if (!cell) {
            UINib *tableCell = [UINib nibWithNibName:@"g5ReminderTableViewCell" bundle:resourcesBundle] ;
            [self.reminderTableView registerNib:tableCell forCellReuseIdentifier:@"g5ReminderTableViewCell"];
            cell = [self.reminderTableView dequeueReusableCellWithIdentifier:@"g5ReminderTableViewCell"];
        }
        
        g5Condition *currentReminder = [[g5ReminderManager sharedManager] reminderForID:currentReminderUID];

        [cells addObject:cell];
    }
}

#pragma mark - Actions

- (IBAction)didPressCreateNewReminderButton:(id)sender {
    [self hideCenterButtonWithCompletion:^{
        [self bounceCornerButtonOntoScreenWithCompletion:nil];
    }];
}

- (IBAction)didPressBackButton:(id)sender {
    [self hideCornerButtonsWithCompletion:^{
        [self bounceCenterButtonOntoScreenWithCompletion:nil];
    }];
}

- (IBAction)didPressNextButton:(id)sender {
    
}

#pragma mark - Animations

- (void)displayCornerButtons {
    self.centerButtonBottomConstraint.constant = -self.centerButtonHeightConstraint.constant;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self.nextButtonContainerView setTransform:CGAffineTransformRotate(self.nextButtonContainerView.transform, -M_PI_2)];
                         [self.backButtonContainerView setTransform:CGAffineTransformRotate(self.backButtonContainerView.transform, M_PI_2)];
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

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

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    g5ReminderTableViewCell *cell = [cells objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cells.count;
}

@end
