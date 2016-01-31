

#import <UIKit/UIKit.h>

@interface LivePopup : UIView

@property(nonatomic) CGFloat contentViewHeight;

@property(nonatomic, strong) IBOutlet NSLayoutConstraint *containerViewHeightOffsetFromCenterConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *containerViewWidthConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;
@property(nonatomic, strong) IBOutlet UIView *view;
@property(nonatomic, strong) IBOutlet UIView *contentView;
@property(nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property(nonatomic, strong) IBOutlet UIButton *xButton;

- (void)present;
- (void)dismiss;
- (IBAction)pressCloseButton:(id)sender;

@end
