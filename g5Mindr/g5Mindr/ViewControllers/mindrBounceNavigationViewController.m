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

#pragma mark - g5BounceNavigationDatasource

- (UIColor *)primaryFillColor {
    return PRIMARY_FILL_COLOR;
}

- (UIColor *)secondaryFillColor {
    return SECONDARY_FILL_COLOR;
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

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController*)fromVC toViewController:(UIViewController*)toVC {
    
    if (operation != UINavigationControllerOperationNone) {
        if ( [fromVC isKindOfClass:[UITableViewController class]] && [toVC isKindOfClass:[UITableViewController class]] ) {
            return [AMWaveTransition transitionWithOperation:operation];
        }
    }
    return nil;
}

@end
