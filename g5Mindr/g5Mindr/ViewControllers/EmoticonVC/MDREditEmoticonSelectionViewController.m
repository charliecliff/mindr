#import "MDREditEmoticonSelectionViewController.h"
#import "MDRCreateReminderTitleViewController.h"
#import "MDREmoticonCollectionViewController.h"
#import "g5EmoticonCell.h"
#import "HROPageControl.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import <PBJHexagonFlowLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const MDRSelectEmoticonTitle = @"Choose an Emoticon";
static NSString *const MDREmbedEmoticonPageViewController = @"embed_emoticon_page_view_controller";

@interface MDREditEmoticonSelectionViewController ()

// PRIVATE
@property(nonatomic) NSInteger selectedPageIndex;
@property(nonatomic, strong) NSArray *emoticonImageNames;
@property(nonatomic, strong) NSArray * orderedViewControllers;
@property(nonatomic, strong) UIPageViewController *emoticonPageVC;

// BINDING
@property(nonatomic, weak) IBOutlet HROPageControl *pageControl;

@end

@implementation MDREditEmoticonSelectionViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"MDREmoticonSelection" bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bounceNavigationController.delegate = self;
    [self.bounceNavigationController reload];
    [self.bounceNavigationController displayCornerButtons:YES bottomButton:NO bounceButton:NO withCompletion:nil];
}

#pragma mark - g5BounceNavigationDelegate

- (void)didPressRightButton {
    
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didPressLeftButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
