//
//  g5ReminderListViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HROBounceNavigationDelegate <NSObject>

@required
- (void)didPressCenterButton;
- (void)didPressPreviousButton;
- (void)didPressNextButton;
- (void)didPressCancelButton;

@optional
- (void)didPressRightButton;
- (void)didPressLeftButton;
- (void)didPressBounceButton;
- (void)didPressBottomButton;

@end

@protocol HROBounceNavigationDatasource <NSObject>

@optional
- (UIColor *)rightButtonFillColor;
- (UIColor *)leftButtonFillColor;
- (UIColor *)bounceButtonFillColor;
- (UIColor *)bottomButtonFillColor;

- (UIColor *)rightButtonDisabledFillColor;
- (UIColor *)leftButtonDisabledFillColor;
- (UIColor *)bounceButtonDisabledFillColor;
- (UIColor *)bottomButtonDisabledFillColor;

- (UIColor *)strokeColor;
- (UIColor *)borderColor;
- (UIColor *)textColor;

- (UIImage *)leftCornerButtonImage;
- (UIImage *)rightCornerButtonImage;
- (UIImage *)bounceButtonImage;
- (UIImage *)bottomButtonImage;

@end

@interface HROBounceNavigationController : UIViewController

@property(nonatomic, strong) id<HROBounceNavigationDelegate> delegate;
@property(nonatomic, strong) id<HROBounceNavigationDatasource> datasource;

@property(nonatomic, strong, readonly) UINavigationController *navigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController withDelegate:(id<HROBounceNavigationDelegate>)delegate withDatasource:(id<HROBounceNavigationDatasource>)datasource;

- (void)setLeftButtonEnabled:(BOOL)nextButtonEnabled;
- (void)setRightButtonEnabled:(BOOL)nextButtonEnabled;
- (void)setBottomButtonEnabled:(BOOL)nextButtonEnabled;
- (void)setBounceButtonEnabled:(BOOL)nextButtonEnabled;

- (void)displayCornerButtons:(BOOL)corners bottomButton:(BOOL)bottom bounceButton:(BOOL)bounce withCompletion:(void (^)(void))completion;

- (void)reload;

@end
