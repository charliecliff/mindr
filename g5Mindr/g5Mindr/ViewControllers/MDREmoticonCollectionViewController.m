#import "MDREmoticonCollectionViewController.h"
#import "g5EmoticonCell.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import <PBJHexagonFlowLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MDREmoticonCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHexagonFlowLayout];
    [self bindToReminder];
}

#pragma mark - Set Up

- (void)setUpHexagonFlowLayout {
    
    CGFloat numberOfCellsInFirstRow = 3;
    CGFloat cellSize = [[UIScreen mainScreen] bounds].size.width/numberOfCellsInFirstRow;
    
    PBJHexagonFlowLayout *flowLayout = [[PBJHexagonFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(cellSize, cellSize);
    flowLayout.itemsPerRow = numberOfCellsInFirstRow;
    
    [self.collectionView setCollectionViewLayout:flowLayout];
}

#pragma mark - Binding

- (void)bindToReminder {
    __weak __typeof(self)weakSelf = self;
    [RACObserve(self.reminder, emoticonUnicodeCharacter) subscribeNext:^(NSString *mewEmoticon) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
    }];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.emoticonUnicodeCharacters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    g5EmoticonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emoticon_cell" forIndexPath:indexPath];

    // Forcing a Layout
    [cell.contentView setNeedsLayout];
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
    NSString *selectedEmoticonImageName = [self.emoticonUnicodeCharacters objectAtIndex:cellNumber];
    [cell configureWithEmoticonName:selectedEmoticonImageName
             withOuterRingWithColor:[UIColor whiteColor]
             withInnerRingWithColor:PRIMARY_STROKE_COLOR];
    
    [cell setHasSelectedEmoticon:[selectedEmoticonImageName isEqualToString:self.reminder.emoticonUnicodeCharacter]];
    
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger newSelectedCellNumber = indexPath.row;
    NSInteger previousSelectedCellNumber = [self.emoticonUnicodeCharacters indexOfObject:self.reminder.emoticonUnicodeCharacter];
    
    NSString *selectedEmoticon = [self.emoticonUnicodeCharacters objectAtIndex:newSelectedCellNumber];
    self.reminder.emoticonUnicodeCharacter = selectedEmoticon;
    
    [UIView setAnimationsEnabled:NO];

    [collectionView performBatchUpdates:^{
        [collectionView reloadItemsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:previousSelectedCellNumber inSection:0]]];
    } completion:^(BOOL finished) {
        [UIView setAnimationsEnabled:YES];
    }];
}

@end
