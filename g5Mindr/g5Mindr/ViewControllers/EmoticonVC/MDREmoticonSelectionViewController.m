#import "MDREmoticonSelectionViewController.h"
#import "MDRCreateReminderTitleViewController.h"
#import "MDREmoticonCollectionViewController.h"
#import "g5EmoticonCell.h"
#import "HROPageControl.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import "PBJHexagonFlowLayout.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const MDRSelectEmoticonTitle = @"Choose an Emoticon";
static NSString *const MDREmbedEmoticonPageViewController = @"embed_emoticon_view_controller";

@interface MDREmoticonSelectionViewController ()

// PRIVATE
@property(nonatomic) NSInteger selectedPageIndex;
@property(nonatomic, strong) NSArray *emoticonImageNames;
@property(nonatomic, strong) NSArray * orderedViewControllers;

// BINDING
@property(nonatomic, weak) IBOutlet HROPageControl *pageControl;

@end

@implementation MDREmoticonSelectionViewController

#pragma mark - Init

- (instancetype)initWithReminder:(MDRReminder *)reminder {
    self = [super init];
    if (self) {
        self.reminder = reminder;
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedPageIndex =0;
      
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = MDRSelectEmoticonTitle;
    self.navigationItem.hidesBackButton = YES;
    
    [self setUpPageControl];
    [self bindToReminder];
    [self scrollToViewControllerAtIndex:self.selectedPageIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
}

#pragma mark - Set Up

- (void)setUpPageControl {
    self.pageControl.underscoreColor = [UIColor whiteColor];
    self.pageControl.unselectedColor = SLATE_BLUE_COLOR;

    UIImage *image1 = [UIImage imageNamed:@"add_new_time"];
    UIImage *image2 = [UIImage imageNamed:@"add_new_time"];
    UIImage *image3 = [UIImage imageNamed:@"add_new_time"];
    UIImage *image4 = [UIImage imageNamed:@"add_new_time"];
    UIImage *image5 = [UIImage imageNamed:@"add_new_time"];
    UIImage *image6 = [UIImage imageNamed:@"add_new_time"];

    NSArray *iconArray = @[image1,
                           image2,
                           image3,
                           image4,
                           image5,
                           image6];
    self.pageControl.icons = iconArray;
}

#pragma mark - Binsing

- (void)bindToReminder {
    __weak __typeof(self)weakSelf = self;
    [RACObserve(self.reminder, hasEmoji) subscribeNext:^(NSNumber *hasEmojiNumberValue) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.bounceNavigationController setRightButtonEnabled:[hasEmojiNumberValue boolValue]];
    }];
}

#pragma mark - Segue

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:MDREmbedEmoticonPageViewController]) {
		 MDREmoticonCollectionViewController *emoticonCollectionVC = segue.destinationViewController;
		 
		 NSError *error;
		 NSString *txtFilePath = [[NSBundle mainBundle] pathForResource:@"Ordered_Emojis" ofType:@"txt"];
		 NSString *txtFileContents = [NSString stringWithContentsOfFile:txtFilePath
															   encoding:NSUTF8StringEncoding
																  error:&error];
		 NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
		 NSArray *emojiCharacter = [txtFileContents componentsSeparatedByCharactersInSet:newlineCharSet];
		 emoticonCollectionVC.emoticonUnicodeCharacters = emojiCharacter;
		 emoticonCollectionVC.reminder = self.reminder;
    }
}

- (void)scrollToViewControllerAtIndex:(NSInteger)index {
}

- (void)updateForDisplayedViewController:(UIViewController *)viewController {
    self.selectedPageIndex = [self.orderedViewControllers indexOfObject:viewController];
    [self.pageControl setSelectedIconAtIndex:self.selectedPageIndex];
}

@end
