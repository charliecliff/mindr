

#import "LivePopup.h"

@interface LivePopup () {
    CGFloat contentViewWidth;
}

@end

@implementation LivePopup

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
        [self configureContentViewLayoutConatraints];
        [self configureContentViewWithRoundedCorners];
        return self;
    }
    return nil;
}

- (void)configureContentViewLayoutConatraints {
    contentViewWidth = self.containerViewWidthConstraint.constant;
    self.contentViewHeight = self.containerViewHeightConstraint.constant;
    self.containerViewWidthConstraint.constant = 0;
    self.containerViewHeightConstraint.constant = 0;
    [self layoutIfNeeded];
}

- (void)configureContentViewWithRoundedCorners {
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
}

#pragma mark - Animations

- (void)present {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [self addSelfToApplicationRootViewController];
    [self resizeViewToFitScreen];
    [self displayContentView];
}

- (void)dismiss {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.containerViewWidthConstraint.constant = 0;
    self.containerViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
        self.backgroundImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addSelfToApplicationRootViewController {
    UIViewController *viewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    while ([viewController presentedViewController]) viewController = [viewController presentedViewController];
    UIView *vcView = viewController.view;
    [vcView addSubview:self];
}

- (void)resizeViewToFitScreen {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    [self setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    UIView *subView = [self.subviews objectAtIndex:0];
    [subView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
}

- (void)displayContentView {
    self.containerViewWidthConstraint.constant = contentViewWidth;
    self.containerViewHeightConstraint.constant = self.contentViewHeight;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        self.backgroundImageView.alpha = 0.3;
    } completion:nil];
}

- (void)hideContentView {
    self.containerViewWidthConstraint.constant = 0;
    self.containerViewHeightConstraint.constant = 0;
    [UIView animateWithDuration:.2 animations:^{
        [self layoutIfNeeded];
        self.backgroundImageView.alpha = 0.0;
    } completion:nil];
}

#pragma mark - Actions

- (IBAction)pressCloseButton:(id)sender {
    [self dismiss];
}

#pragma mark - Keyboard Notifications

-(void)keyboardDidShow:(NSNotification*)notification {
    CGFloat keyboardHeightForScreen = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    CGFloat maxVisibleYcoordinate = [[UIScreen mainScreen] bounds].size.height - keyboardHeightForScreen;
    CGFloat bottomYCoordinateOfContentView = [[UIScreen mainScreen] bounds].size.height/2 + self.containerViewHeightConstraint.constant/2;
    
    self.containerViewHeightOffsetFromCenterConstraint.constant = -((bottomYCoordinateOfContentView - maxVisibleYcoordinate ) + 10);
    [UIView animateWithDuration:.1 animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

@end
