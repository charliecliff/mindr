//
//  PBJHexagonFlowLayout.m
//
//  Created by Patrick Piemonte on 10/30/13.
//  Copyright (c) 2013-present, Patrick Piemonte, http://patrickpiemonte.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "PBJHexagonFlowLayout.h"

CG_INLINE CGFloat CGFloat_nearbyint(CGFloat cgfloat) {
#if defined(__LP64__) && __LP64__
    return nearbyint(cgfloat);
#else
    return nearbyintf(cgfloat);
#endif
}

CG_INLINE CGFloat CGFloat_floor(CGFloat cgfloat) {
#if defined(__LP64__) && __LP64__
    return floor(cgfloat);
#else
    return floorf(cgfloat);
#endif
}

CG_INLINE CGFloat_ceil(CGFloat cgfloat) {
#if defined(__LP64__) && __LP64__
    return ceil(cgfloat);
#else
    return ceil(cgfloat);
#endif
}

@interface PBJHexagonFlowLayout ()
{
    NSInteger _itemsPerRow;
}

@end

@implementation PBJHexagonFlowLayout

@synthesize itemsPerRow = _itemsPerRow;

#pragma mark - UICollectionViewLayout Subclass hooks

- (void)prepareLayout
{
    [super prepareLayout];
    
    if (_itemsPerRow == 0)
        _itemsPerRow = 4;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *layoutAttributes = [[NSMutableArray alloc] init];
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0 ; i < numberOfItems; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [layoutAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfItemsInASetOfTwoRows = ((_itemsPerRow * 2) - 1);
    
    NSInteger currentItem = indexPath.row;
    NSInteger numberOfPairsOfRows = CGFloat_floor( currentItem / numberOfItemsInASetOfTwoRows );

    NSInteger currentItemWithinAPairOfRows = currentItem % numberOfItemsInASetOfTwoRows;

    NSInteger numberOfCompeletedRowsWithinTheCurrentPairOfRows = CGFloat_floor( currentItemWithinAPairOfRows / _itemsPerRow );

    NSInteger currentRow = 2 * numberOfPairsOfRows + numberOfCompeletedRowsWithinTheCurrentPairOfRows;

    NSInteger currentColumn;
    if (numberOfCompeletedRowsWithinTheCurrentPairOfRows == 1)
        currentColumn = currentItemWithinAPairOfRows - _itemsPerRow;    // An Even Row: (_itemsPerRow - 1)
    else
        currentColumn = currentItemWithinAPairOfRows;                   // An Odd Row: (_itemsPerRow)

    
    CGFloat horiOffset = ((currentRow % 2) != 0) ? self.itemSize.width * 0.5f : 0 ;
    CGFloat vertOffset = self.sectionInset.top;
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.size = self.itemSize;
    
    attributes.center = CGPointMake( ( (currentColumn * self.itemSize.width) + (0.5f * self.itemSize.width) + horiOffset),
                                     ( (currentRow* self.itemSize.height) + (0.5f * self.itemSize.height) + vertOffset) );
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO;
}

- (CGSize)collectionViewContentSize
{
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];

    CGFloat contentWidth = self.collectionView.bounds.size.width;
    
    CGFloat numberOfRows;
    CGFloat numberOfFullRows  = 2 * CGFloat_floor(numberOfItems / ((_itemsPerRow * 2) - 1));
    CGFloat numberOfLeftOverItems = numberOfItems % ((_itemsPerRow * 2) - 1);
    if (numberOfLeftOverItems > _itemsPerRow) {
        numberOfRows = numberOfFullRows + 2;
    }
    else {
        numberOfRows = numberOfFullRows + 1;
    }
    
//    CGFloat contentHeight = ( (numberOfRows * 0.75f) * self.itemSize.height) + (0.5f + self.itemSize.height);
    CGFloat contentHeight = (numberOfRows * self.itemSize.height);
    
    CGSize contentSize = CGSizeMake(contentWidth, contentHeight + self.sectionInset.top + self.sectionInset.bottom);
    return contentSize;
}

@end
