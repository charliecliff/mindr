//
//  HROPickerTableView.m
//  g5Mindr
//
//  Created by Charles Cliff on 6/4/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "HROPickerTableView.h"

#define BUFFER 2

@interface HROPickerTableView () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat deltaR;
    CGFloat deltaG;
    CGFloat deltaB;
    CGFloat deltaA;
    
    const CGFloat *selectColorComponents;
    const CGFloat *normalColorComponents;
    
    NSInteger selectedRow;
}

@end

@implementation HROPickerTableView

#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        
        self.shouldInterpolateColors    = NO;
        self.selectedTextColor          = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.normalTextColor            = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        self.textAlignment              = NSTextAlignmentCenter;
        
        selectedRow = 0;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    
    self.shouldInterpolateColors    = NO;
    self.selectedTextColor          = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.normalTextColor            = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.textAlignment              = NSTextAlignmentCenter;
}

#pragma mark - Setters

-(void)setSelectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    if (self.normalTextColor)
        [self calculateColorDelta];
}

-(void)setNormalTextColor:(UIColor *)normalTextColor {
    _normalTextColor = normalTextColor;
    if (self.selectedTextColor)
        [self calculateColorDelta];
}

#pragma mark - Public Scrolling Methods

- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *offsetIndexPath = [NSIndexPath indexPathForRow:indexPath.row + BUFFER + 1 inSection:indexPath.section];
    [self scrollToRowAtIndexPath:offsetIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    [self centerTableView:self];
}

#pragma mark - Helpers

- (void)calculateColorDelta {
    selectColorComponents = CGColorGetComponents(self.selectedTextColor.CGColor);
    normalColorComponents = CGColorGetComponents(self.normalTextColor.CGColor);
    
    deltaR = selectColorComponents[0] - normalColorComponents[0];
    deltaG = selectColorComponents[1] - normalColorComponents[1];
    deltaB = selectColorComponents[2] - normalColorComponents[2];
    deltaA = selectColorComponents[3] - normalColorComponents[3];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = self.frame.size.height / (BUFFER * 2);
    return height;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.pickerDatasource componentsForPickerView:self].count + 2*(BUFFER + 1);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell   = [[UITableViewCell alloc] init];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.backgroundColor    = [UIColor clearColor];
    
    NSInteger count = [self.pickerDatasource componentsForPickerView:self].count;
    if (indexPath.row < (BUFFER + 1) || indexPath.row > (count + BUFFER) ) {
        return cell;
    }
    
    NSString *text = [[self.pickerDatasource componentsForPickerView:self] objectAtIndex:(indexPath.row - (BUFFER + 1)) ];
    cell.textLabel.text          = text;
    cell.textLabel.textAlignment = self.textAlignment;
    cell.textLabel.textColor     = self.normalTextColor;
    
    if (indexPath.row == selectedRow) {
        cell.textLabel.textColor     = self.selectedTextColor;
    }
    
    return cell;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        if ([scrollView isKindOfClass:[UITableView class]])
            [self centerTableView:((UITableView *)scrollView)];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isKindOfClass:[UITableView class]]) {
        CGFloat contentOffset = [((UITableView *)scrollView) contentOffset].y;

        CGFloat bandTop       = ((UITableView *)scrollView).frame.size.height/2 - ((UITableView *)scrollView).frame.size.height/8;
        CGFloat bandBottom    = ((UITableView *)scrollView).frame.size.height/2 + ((UITableView *)scrollView).frame.size.height/8;
        
        NSArray *cells = [((UITableView *)scrollView) visibleCells];
        for (UITableViewCell *currentCell in cells) {
            
            CGFloat weight = 1;
            
            if (!self.shouldInterpolateColors) {
                CGFloat currentCellTop     = currentCell.frame.origin.y - contentOffset;
                CGFloat currentCellBottom  = currentCell.frame.origin.y + currentCell.frame.size.height - contentOffset;
                
                if ( (bandTop < currentCellTop) && (currentCellTop < bandBottom) ) {
                    weight = 1 - ABS(bandBottom - currentCellTop) / (((UITableView *)scrollView).frame.size.height / 4);   // Fucking Dumb...
                }
                if ( (bandTop < currentCellBottom) && (currentCellBottom < bandBottom) ) {
                    weight = 1 - ABS(bandTop - currentCellBottom) / (((UITableView *)scrollView).frame.size.height / 4);   // Fucking Dumb...
                }
                if ( ABS(bandTop - currentCellTop) < 1 && ABS(bandBottom - currentCellBottom) < 1 ) {
                    weight = 0;
                }
            }
            else {
                CGFloat currentCellYPosition = currentCell.frame.origin.y + CGRectGetMidY(currentCell.bounds) - contentOffset;
                CGFloat cellYPositionNormalizedToCenter = ABS(CGRectGetMidY(((UITableView *)scrollView).frame) - currentCellYPosition);
                weight = cellYPositionNormalizedToCenter/CGRectGetMidY(((UITableView *)scrollView).frame);
            }
            
            currentCell.textLabel.textColor = [UIColor colorWithRed:(selectColorComponents[0] - deltaR*weight)
                                                              green:(selectColorComponents[1] - deltaG*weight)
                                                               blue:(selectColorComponents[2] - deltaB*weight)
                                                              alpha:1];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UITableView class]])
        [self centerTableView:((UITableView *)scrollView)];
}

- (void)centerTableView:(UITableView *)tableView {
    NSIndexPath *pathForCenterCell = [tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(tableView.bounds), CGRectGetMidY(tableView.bounds))];
    
    NSInteger count = [self.pickerDatasource componentsForPickerView:self].count;
    if ( pathForCenterCell.row < (BUFFER + 1) ) {
        pathForCenterCell = [NSIndexPath indexPathForRow:BUFFER + 1 inSection:pathForCenterCell.section];
    }
    
    if ( pathForCenterCell.row > (count + BUFFER) ) {
        pathForCenterCell = [NSIndexPath indexPathForRow:count + BUFFER  inSection:pathForCenterCell.section];
    }
    
    [tableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    selectedRow = pathForCenterCell.row;
    [self.pickerDelegate pickerView:self didSelectItemAtRow:pathForCenterCell.row - (BUFFER + 1)];
}

@end
