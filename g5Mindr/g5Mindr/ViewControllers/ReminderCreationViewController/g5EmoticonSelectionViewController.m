//
//  g5EmoticonSelectionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5EmoticonSelectionViewController.h"
#import "g5ReminderDetailViewController.h"
#import "RootCell.h"
#import "g5Reminder.h"
#import "g5ConfigAndMacros.h"
#import <PBJHexagonFlowLayout.h>

@interface g5EmoticonSelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) NSArray *emoticonImageNames;

@property(nonatomic, strong) IBOutlet UICollectionView *hexagonGridViewController;
@property(nonatomic, strong) IBOutlet UIView *nextButtonBackground;
@property(nonatomic, strong) IBOutlet UIView *backButtonBackground;
@end

@implementation g5EmoticonSelectionViewController

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
    
    [self setUpNextButtonBackground];
    [self setUpBackButtonBackground];
    [self setUpHexagonFlowLayout];
    [self setUpEmoticonImageNames];
    
    UINib *nib = [UINib nibWithNibName:RootCell_XIB bundle:nil];;
    [self.hexagonGridViewController registerNib:nib forCellWithReuseIdentifier:@"RootCellID"];
}

#pragma mark - Set Up

- (void)setUpHexagonFlowLayout {
    
    CGFloat numberOfCellsInFirstRow = 3;
    CGFloat cellSize = [[UIScreen mainScreen] bounds].size.width/numberOfCellsInFirstRow;
    
    PBJHexagonFlowLayout *flowLayout = [[PBJHexagonFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(60, 0, 60, 0);
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.itemsPerRow = numberOfCellsInFirstRow;
    
    [self.hexagonGridViewController setCollectionViewLayout:flowLayout];
}

- (void)setUpEmoticonImageNames {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.emoticonImageNames = [plistDictionary objectForKey:@"emoticons"];
}

- (void)setUpNextButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.nextButtonBackground bounds].size.width, [self.nextButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.nextButtonBackground bounds]),CGRectGetMidY([self.nextButtonBackground bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.nextButtonBackground.frame.size.width, self.nextButtonBackground.frame.size.height) radius:self.nextButtonBackground.frame.size.width startAngle:3*M_PI_4 endAngle:2*M_PI clockwise:YES];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[PRIMARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.nextButtonBackground layer] addSublayer:circleLayer];
}

- (void)setUpBackButtonBackground {
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    
    [circleLayer setBounds:CGRectMake(0.0f, 0.0f, [self.backButtonBackground bounds].size.width, [self.backButtonBackground bounds].size.height)];
    [circleLayer setPosition:CGPointMake(CGRectGetMidX([self.backButtonBackground bounds]),CGRectGetMidY([self.backButtonBackground bounds]))];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(0, self.backButtonBackground.frame.size.height) radius:self.backButtonBackground.frame.size.width startAngle:M_PI_2 endAngle:3*M_PI_2 clockwise:NO];
    
    [circleLayer setPath:[path CGPath]];
    [circleLayer setStrokeColor:[PRIMARY_STROKE_COLOR CGColor]];
    [circleLayer setFillColor:[SECONDARY_FILL_COLOR CGColor]];
    [circleLayer setLineWidth:4.0f];
    
    [[self.backButtonBackground layer] addSublayer:circleLayer];
}

#pragma mark - Actions

- (IBAction)didPressBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressNextButton:(id)sender {
    g5ReminderDetailViewController *vc = [[g5ReminderDetailViewController alloc] initWithReminder:self.reminder];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emoticonImageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootCellID" forIndexPath:indexPath];
    if (!cell) {
        UINib *tableCell = [UINib nibWithNibName:@"RootCell" bundle:resourcesBundle] ;
        [self.hexagonGridViewController registerNib:tableCell forCellWithReuseIdentifier:@"RootCellID"];
        cell = [self.hexagonGridViewController dequeueReusableCellWithReuseIdentifier:@"RootCellID" forIndexPath:indexPath];
    }
    
    // 1. Animation Constants
    CGFloat cellInflationSize = 1.2;
    CGFloat randomCellAnimationDelay = 0.05 * (rand() % 10);
    CGFloat durationOfFirstAnimation = 0.5;

    // 2. Initial Size should be 0 x 0
    CATransform3D scale = CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 1);
    cell.contentView.alpha = 0.6;
    cell.contentView.layer.transform = scale;
    
    // 3. Inflate beyond the size constraints of a Cell
    [UIView animateWithDuration:durationOfFirstAnimation
                          delay:randomCellAnimationDelay
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CATransform3D inflatedScale = CATransform3DScale(CATransform3DIdentity,
                                                                          cellInflationSize,
                                                                          cellInflationSize,
                                                                          1.0);
                         cell.contentView.layer.transform = inflatedScale;
                         cell.contentView.alpha = 0.8;
                     }
                     completion:nil];
        
    [UIView animateWithDuration:(1 / cellInflationSize) * durationOfFirstAnimation
                          delay:durationOfFirstAnimation
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         cell.contentView.layer.transform = CATransform3DIdentity;
                         cell.contentView.alpha = 1.0;
                     }
                     completion:nil];
    
    // 4. Configureing the Colors
    [cell configureOuterRingWithColor:[UIColor whiteColor]];
    [cell configureInnerRingWithColor:[UIColor grayColor]];
    
    // 5. Configure the Emoticon
    NSInteger cellNumber = indexPath.row;
    NSString *selectedEmoticonImageName = [self.emoticonImageNames objectAtIndex:cellNumber];
    [cell configureWithEmoticonName:selectedEmoticonImageName];
    [cell setHasSelectedEmoticon:[selectedEmoticonImageName isEqualToString:self.reminder.emoticonImageName]];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger cellNumber = indexPath.row;
    NSString *selectedEmoticonImageName = [self.emoticonImageNames objectAtIndex:cellNumber];
//    self.reminder.emoticonImageName = selectedEmoticonImageName;
    self.reminder.emoticonImageName = @"emoticon_smile";
    
    [UIView setAnimationsEnabled:NO];
    
    [collectionView performBatchUpdates:^{
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}

@end
