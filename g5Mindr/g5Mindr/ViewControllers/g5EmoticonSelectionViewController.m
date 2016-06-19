//
//  g5EmoticonSelectionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5EmoticonSelectionViewController.h"
#import "g5ReminderExplanationViewController.h"
#import "g5EmoticonCell.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import <PBJHexagonFlowLayout.h>

@interface g5EmoticonSelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) NSArray *emoticonImageNames;

@property(nonatomic, strong) IBOutlet UICollectionView *hexagonGridViewController;

@end

@implementation g5EmoticonSelectionViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self != nil) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.title = @"Choose an Emoticon";
    self.navigationItem.hidesBackButton = YES;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    progressLabel.text = @"2/3";
    progressLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:183.0/255.0 blue:230.0/255.0 alpha:1];
    progressLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    [barView addSubview:progressLabel];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barView];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    [self setUpHexagonFlowLayout];
    [self setUpEmoticonImageNames];
    
    UINib *nib = [UINib nibWithNibName:RootCell_XIB bundle:nil];;
    [self.hexagonGridViewController registerNib:nib forCellWithReuseIdentifier:@"RootCellID"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
    [self reload];
}

- (void)reload {
    if ([self.reminder hasEmoticon]) {
        [self.bounceNavigationController setRightButtonEnabled:YES];
    }
    else {
        [self.bounceNavigationController setRightButtonEnabled:NO];
    }
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

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emoticonImageNames.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    g5EmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootCellID" forIndexPath:indexPath];
    if (!cell) {
        UINib *tableCell = [UINib nibWithNibName:@"RootCell" bundle:resourcesBundle] ;
        [self.hexagonGridViewController registerNib:tableCell forCellWithReuseIdentifier:@"RootCellID"];
        cell = [self.hexagonGridViewController dequeueReusableCellWithReuseIdentifier:@"RootCellID" forIndexPath:indexPath];
    }
    // Forcing a Layout
    [cell .contentView setNeedsLayout];
    [cell.contentView layoutIfNeeded];
    
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
        
    // 4. Configure the Emoticon Cell
    NSInteger cellNumber = indexPath.row;
    NSString *selectedEmoticonImageName = [self.emoticonImageNames objectAtIndex:cellNumber];
    [cell configureWithEmoticonName:selectedEmoticonImageName
             withOuterRingWithColor:[UIColor whiteColor]
             withInnerRingWithColor:PRIMARY_STROKE_COLOR];
    
    [cell setHasSelectedEmoticon:[selectedEmoticonImageName isEqualToString:self.reminder.emoticonUnicodeCharacter]];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger newSelectedCellNumber = indexPath.row;
    NSInteger previousSelectedCellNumber = [self.emoticonImageNames indexOfObject:self.reminder.emoticonUnicodeCharacter];

    NSString *selectedEmoticon = [self.emoticonImageNames objectAtIndex:newSelectedCellNumber];
    self.reminder.emoticonUnicodeCharacter = selectedEmoticon;
    
    
    [UIView setAnimationsEnabled:NO];
    
    [collectionView performBatchUpdates:^{
        [collectionView reloadItemsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:previousSelectedCellNumber inSection:0]]];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
    
    [self reload];
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

- (void)didPressNextButton {
    g5ReminderExplanationViewController *vc = [[g5ReminderExplanationViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPressCancelButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
