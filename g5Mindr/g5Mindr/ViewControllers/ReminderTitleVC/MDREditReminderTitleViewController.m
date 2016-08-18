//
//  g5ReminderExplanationViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 4/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDREditReminderTitleViewController.h"
#import "HROBounceNavigationController.h"
#import "g5ReminderManager.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

@interface MDREditReminderTitleViewController () <HROBounceNavigationDatasource>

@end

@implementation MDREditReminderTitleViewController

- (void)viewDidAppear:(BOOL)animated {
//    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:^{
        self.bounceNavigationController.datasource = self;
        [self.bounceNavigationController reload];
        [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
//    }];

}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    assert(false);
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - HROBounceNavigationDatasource

- (UIColor *)rightButtonFillColor {
    return DELETE_FILL_COLOR;
}

- (UIColor *)leftButtonFillColor {
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

- (UIImage *)leftCornerButtonImage {
    return [UIImage imageNamed:@"button_delete"];
}

- (UIImage *)rightCornerButtonImage {
    return [UIImage imageNamed:@"button_back"];
}

@end
