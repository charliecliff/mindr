//
//  RootCell.h
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RootCell_ID     @"RootCellID"
#define RootCell_XIB    @"g5EmoticonCell"
#define RootCell_SIZE   CGSizeMake(160, 145)


@interface g5EmoticonCell : UICollectionViewCell

@property(nonatomic, strong) IBOutlet UIImageView *emojiImageView;
@property(nonatomic, strong) IBOutlet UIImageView *outerRingImageView;
@property(nonatomic, strong) IBOutlet UIImageView *innerRingImageView;

@property(nonatomic) BOOL hasSelectedEmoticon;

- (void)configureWithEmoticonName:(NSString *)emoticonName withOuterRingWithColor:(UIColor *)outerRingColor withInnerRingWithColor:(UIColor *)innerRingColor;

@end
