//
//  g5ConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ConditionViewController.h"
#import "g5ConfigAndMacros.h"

@implementation g5ConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(g5Condition *)condition {
    self = [super init];
    if (self != nil) {
        self.condition = condition;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bounceNavigationController setShouldShowTrashCanOnBounceButton:NO];
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background"]];
    self.view.backgroundColor = background;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate didUpdateCondition:self.condition];
    [super viewWillDisappear:animated];
}

#pragma mark - Actions

- (void)didPressPreviousButton {
    [self.bounceNavigationController displayCornerButtons:NO bottomButton:NO bounceButton:NO withCompletion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressNextButton {
    assert(false);
}

- (void)didPressCancelButton {
    assert(false);
}

@end
