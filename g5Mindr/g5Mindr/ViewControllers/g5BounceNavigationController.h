//
//  g5ReminderListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol g5BounceNavigationDelegate <NSObject>

@required
- (void)didPressCenterButton;
- (void)didPressPreviousButton;
- (void)didPressNextButton;
- (void)didPressCancelButton;

@end

@protocol g5BounceNavigationDatasource <NSObject>

@optional
- (UIColor *)primaryFillColor;
- (UIColor *)secondaryFillColor;
- (UIColor *)strokeColor;
- (UIColor *)borderColor;
- (UIColor *)textColor;

@end

@interface g5BounceNavigationController : UIViewController

@property(nonatomic, strong) id<g5BounceNavigationDelegate> delegate;
@property(nonatomic, strong) id<g5BounceNavigationDatasource> datasource;

@property(nonatomic, strong, readonly) UINavigationController *navigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController withDelegate:(id<g5BounceNavigationDelegate>)delegate withDatasource:(id<g5BounceNavigationDatasource>)datasource;

- (void)setNextButtonEnabled:(BOOL)nextButtonEnabled;

- (void)hideCornerButtonsWithCompletion:(void (^)(void))completion;
- (void)hideCenterButtonWithCompletion:(void (^)(void))completion;
- (void)hidePreviousButtonWithCompletion:(void (^)(void))completion;

- (void)displayCornerButtonsOntoScreenWithCompletion:(void (^)(void))completion;
- (void)displayCenterButtonOntoScreenWithCompletion:(void (^)(void))completion;
- (void)displayPreviousButtonOntoScreenWithCompletion:(void (^)(void))completion;

@end
