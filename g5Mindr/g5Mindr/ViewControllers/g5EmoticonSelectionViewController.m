//
//  g5EmoticonSelectionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5EmoticonSelectionViewController.h"

#import <PBJHexagonFlowLayout.h>



#import "RootCell.h"

@interface g5EmoticonSelectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *hexagonGridViewController;

@end

@implementation g5EmoticonSelectionViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpHexagonFlowLayout];
    
    UINib *nib = [UINib nibWithNibName:RootCell_XIB bundle:nil];;
    [self.hexagonGridViewController registerNib:nib forCellWithReuseIdentifier:@"RootCellID"];
}

#pragma mark - Set Up

- (void)setUpHexagonFlowLayout {
    PBJHexagonFlowLayout *flowLayout = [[PBJHexagonFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.headerReferenceSize = CGSizeZero;
    flowLayout.footerReferenceSize = CGSizeZero;
    flowLayout.itemSize = CGSizeMake(80.0f, 92.0f);
    flowLayout.itemsPerRow = 2;
    
    [self.hexagonGridViewController setCollectionViewLayout:flowLayout];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSBundle *resourcesBundle = [NSBundle mainBundle];
    RootCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RootCellID" forIndexPath:indexPath];
    if (!cell) {
        UINib *tableCell = [UINib nibWithNibName:@"RootCell" bundle:resourcesBundle] ;
        [self.hexagonGridViewController registerNib:tableCell forCellWithReuseIdentifier:@"RootCellID"];
        cell = [self.hexagonGridViewController dequeueReusableCellWithReuseIdentifier:@"RootCellID" forIndexPath:indexPath];
    }
    
    
    [cell configureWithInt:indexPath.item];
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
