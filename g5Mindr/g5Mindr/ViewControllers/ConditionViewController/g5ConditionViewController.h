//
//  g5ConditionViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@class g5Condition;

@protocol g5ConditionDelegate <NSObject>

@required
- (void)didUpdateCondition:(g5Condition *)condition;

@end

@interface g5ConditionViewController : UIViewController

@property(nonatomic, strong) g5Condition *condition;
@property(nonatomic, strong) id<g5ConditionDelegate> delegate;

@property(nonatomic, strong) IBOutlet UIButton *backButton;
@property(nonatomic, strong) IBOutlet UIImageView *backButtonBackgroundImageView;

- (void)setUpBackButton;
- (IBAction)didPressBackButton:(id)sender;

@end
