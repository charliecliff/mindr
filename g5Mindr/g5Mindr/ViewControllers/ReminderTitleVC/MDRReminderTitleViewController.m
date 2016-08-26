#import "MDRReminderTitleViewController.h"
#import "HROBounceNavigationController.h"
#import "g5ReminderManager.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

@interface MDRReminderTitleViewController () <HROBounceNavigationDelegate, UITextFieldDelegate> {
    CGFloat initialBottomConstraintConstant;
    BOOL textFieldIsActive;
}

@property(nonatomic, strong) UITapGestureRecognizer *selectionTapGestureRecognizer;

@property(nonatomic, strong) IBOutlet UIView *backgroundView;
@property(nonatomic, strong) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UIButton *deleteTextFieldButton;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldBottomConstraint;
@property(nonatomic, strong) IBOutlet NSLayoutConstraint *textFieldHeightConstraint;
@property(nonatomic, strong) IBOutlet UILabel *reminderExplanationLabel;

@end

@implementation MDRReminderTitleViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self != nil) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - view Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.reminderExplanationLabel setTextColor:SECONDARY_FILL_COLOR];
    [self setTextFieldActive:NO];
    
    self.reminderExplanationLabel.text = self.reminder.title;
    self.textField.text = self.reminderExplanationLabel.text;

    self.selectionTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectExplanation)];
    [self.backgroundView addGestureRecognizer:self.selectionTapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
    
    initialBottomConstraintConstant = self.textFieldBottomConstraint.constant;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

#pragma mark - Actions

-(void)didSelectExplanation {
    if (!textFieldIsActive) {
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - Toggling the Text Field 

- (void)setTextFieldActive:(BOOL)isActive {
    textFieldIsActive = isActive;
    if (textFieldIsActive) {
        [self.backgroundView.layer setCornerRadius:self.backgroundView.frame.size.height/2];
        [self.backgroundView.layer setBorderColor:[UIColor clearColor].CGColor];
        [self.backgroundView.layer setBorderWidth:2.0];
        [self.backgroundView setBackgroundColor:SECONDARY_FILL_COLOR];
        
        [self.textField setHidden:NO];
        [self.deleteTextFieldButton setHidden:NO];
        [self.reminderExplanationLabel setHidden:YES];
    }
    else {
        [self.backgroundView.layer setCornerRadius:self.backgroundView.frame.size.height/2];
        [self.backgroundView.layer setBorderColor:SECONDARY_FILL_COLOR.CGColor];
        [self.backgroundView.layer setBorderWidth:2.0];
        [self.backgroundView setBackgroundColor:[UIColor clearColor]];
        
        [self.textField setHidden:YES];
        [self.deleteTextFieldButton setHidden:YES];
        [self.reminderExplanationLabel setText:self.textField.text];
        [self.reminderExplanationLabel setHidden:NO];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.textField resignFirstResponder];
    return YES;
}

#pragma mark - Keyboard Notifications

- (void)keyboardDidShow:(NSNotification *)notification {
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat newBottomConstraint = ([UIScreen mainScreen].bounds.size.height - keyboardSize.height)/2
        - self.textFieldHeightConstraint.constant/2
        - self.navigationController.navigationBar.frame.size.height
        + keyboardSize.height;
    self.textFieldBottomConstraint.constant = newBottomConstraint;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self setTextFieldActive:YES];
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {

    self.textFieldBottomConstraint.constant = initialBottomConstraintConstant;
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [self.view layoutIfNeeded];
                         [self setTextFieldActive:NO];
                     }];
    
    self.reminder.title = self.textField.text;
}

@end
