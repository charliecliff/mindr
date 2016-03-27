//
//  RootCell.m
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 PlayAdz. All rights reserved.
//

#import "RootCell.h"

@interface RootCell ()

// Outlets
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation RootCell

#pragma mark - Configuration
- (void)configureWithInt:(NSInteger)anInteger
{
    _titleLabel.text = [NSString stringWithFormat:@"%ld", (long)anInteger];
}

@end
