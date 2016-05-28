//
//  mindrBounceNavigationViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "mindrBounceNavigationViewController.h"
#import "g5ConditionViewController.h"
#import "g5ConfigAndMacros.h"

#import "AMWaveTransition.h"

@interface mindrBounceNavigationViewController ()

@end

@implementation mindrBounceNavigationViewController

#pragma mark - Setters

- (void)setShouldShowTrashCanOnBounceButton:(BOOL)shouldShowTrashCanOnBounceButton {
    _shouldShowTrashCanOnBounceButton = shouldShowTrashCanOnBounceButton;
    [self reload];
}

#pragma mark - g5BounceNavigationDatasource

- (UIColor *)rightButtonFillColor {
    return PRIMARY_FILL_COLOR;

}

- (UIColor *)leftButtonFillColor {
    return SECONDARY_FILL_COLOR;
}

- (UIColor *)bounceButtonFillColor {
    if (self.shouldShowTrashCanOnBounceButton) {
        return DELETE_FILL_COLOR;
    }
    return SECONDARY_FILL_COLOR;
}

- (UIColor *)bottomButtonFillColor {
    return PRIMARY_FILL_COLOR;
}

- (UIColor *)strokeColor {
    return PRIMARY_STROKE_COLOR;
}

- (UIColor *)borderColor {
    return SECONDARY_FILL_COLOR;
}

- (UIColor *)textColor {
    return [UIColor whiteColor];
}

- (UIImage *)bounceButtonImage {
    if (self.shouldShowTrashCanOnBounceButton) {
        return [UIImage imageNamed:@"button_delete"];
    }
    else {
        return [UIImage imageNamed:@"button_back"];
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    
    if (operation != UINavigationControllerOperationNone) {
        if ( [toVC isKindOfClass:[UITableViewController class]] &&
             [fromVC isKindOfClass:[UITableViewController class]]) {
            return [AMWaveTransition transitionWithOperation:operation];
        }
    }
    return nil;
}

@end
