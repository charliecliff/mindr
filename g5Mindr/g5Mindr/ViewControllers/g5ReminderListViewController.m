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

@interface g5ReminderListViewController () {
    NSMutableArray *cells;
}

@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *nextButtonContainerView;

@property(nonatomic, strong) IBOutlet UIView *backButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *backButtonContainerView;

@property(nonatomic, strong) IBOutlet UIImageView *createReminderButtonBackgroundImage;
@property(nonatomic, strong) IBOutlet UITableView *reminderTableView;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonHeightConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *centerButtonBottomConstraint;

@end

@implementation g5ReminderListViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpCreateReminderButtonBackground];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpBackButtonBackground];
    [self setUpNextButtonBackground];
    
    [self.nextButtonContainerView setTransform:CGAffineTransformRotate(self.nextButtonContainerView.transform, M_PI_2)];
    [self.backButtonContainerView setTransform:CGAffineTransformRotate(self.backButtonContainerView.transform, -M_PI_2)];

    [self setUpCells];
    
    [self.reminderTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}

#pragma mark - Set Up

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
    [self displayCornerButtons];
}

- (IBAction)didPressBackButton:(id)sender {
    [self hideCornerButtons];
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

- (void)hideCornerButtons {
    self.centerButtonBottomConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self.nextButtonContainerView setTransform:CGAffineTransformRotate(self.nextButtonContainerView.transform, M_PI_2)];
                         [self.backButtonContainerView setTransform:CGAffineTransformRotate(self.backButtonContainerView.transform, -M_PI_2)];
                     }
                     completion:^(BOOL finished) {
                         
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
