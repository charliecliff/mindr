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
static NSString *const MDREmbedEmoticonPageViewController = @"embed_emoticon_page_view_controller";

@interface MDREmoticonSelectionViewController () <HROPageControlDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

// PRIVATE
@property(nonatomic) NSInteger selectedPageIndex;
@property(nonatomic, strong) NSArray *emoticonImageNames;
@property(nonatomic, strong) NSArray * orderedViewControllers;
@property(nonatomic, strong) UIPageViewController *emoticonPageVC;

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
  
    self.orderedViewControllers = @[[self collectionViewForEmoticonSet:EMOJI_SHEET_ONE],
                                    [self collectionViewForEmoticonSet:EMOJI_SHEET_TWO],
                                    [self collectionViewForEmoticonSet:EMOJI_SHEET_THREE],
                                    [self collectionViewForEmoticonSet:EMOJI_SHEET_FOUR],
                                    [self collectionViewForEmoticonSet:EMOJI_SHEET_FIVE],
                                    [self collectionViewForEmoticonSet:EMOJI_SHEET_SIX]];
    
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
         MDREmoticonCollectionViewController *emoticonCollectionVC = [self collectionViewForEmoticonSet:@"emoji_smileys"];
         self.emoticonPageVC = (UIPageViewController *)segue.destinationViewController;
         [self.emoticonPageVC setViewControllers:@[emoticonCollectionVC]
                                       direction:UIPageViewControllerNavigationDirectionForward
                                        animated:NO
                                      completion:nil];
         self.emoticonPageVC.doubleSided = NO;
         self.emoticonPageVC.dataSource = self;
         self.emoticonPageVC.delegate = self;
    }
}

#pragma mark - Helpers

- (MDREmoticonCollectionViewController *)collectionViewForEmoticonSet:(NSString *)emoticonSetName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MDREmoticonSelection" bundle:[NSBundle mainBundle]];
    MDREmoticonCollectionViewController *emoticonCollectionVC = [storyboard instantiateViewControllerWithIdentifier:@"collection_vc"];
	
	NSError *error;
	NSString *txtFilePath = [[NSBundle mainBundle] pathForResource:@"Ordered_Emojis" ofType:@"txt"];
	NSString *txtFileContents = [NSString stringWithContentsOfFile:txtFilePath
														  encoding:NSUTF8StringEncoding
															 error:&error];
	NSCharacterSet *newlineCharSet = [NSCharacterSet newlineCharacterSet];
	NSArray *emojiCharacter = [txtFileContents componentsSeparatedByCharactersInSet:newlineCharSet];
	emoticonCollectionVC.emoticonUnicodeCharacters = emojiCharacter;
	
    emoticonCollectionVC.reminder = self.reminder;
    
    return emoticonCollectionVC;
}

- (void)scrollToViewControllerAtIndex:(NSInteger)index {
    MDREmoticonCollectionViewController *currentViewController = ((NSArray *)[self orderedViewControllers])[index];
    [self.emoticonPageVC setViewControllers:@[currentViewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [currentViewController.collectionView reloadData];
    [self updateForDisplayedViewController:currentViewController];
}

- (void)updateForDisplayedViewController:(UIViewController *)viewController {
    self.selectedPageIndex = [self.orderedViewControllers indexOfObject:viewController];
    [self.pageControl setSelectedIconAtIndex:self.selectedPageIndex];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        MDREmoticonCollectionViewController *vc = [self.emoticonPageVC.viewControllers firstObject];
        [self updateForDisplayedViewController:vc];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ( (self.selectedPageIndex - 1) < 0) {
        return nil;
    }
    MDREmoticonCollectionViewController *emoticonCollectionVC = self.orderedViewControllers[self.selectedPageIndex - 1];
    return emoticonCollectionVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ( (self.selectedPageIndex + 1) >= self.orderedViewControllers.count) {
        return nil;
    }
    MDREmoticonCollectionViewController *emoticonCollectionVC = self.orderedViewControllers[self.selectedPageIndex + 1];
    return emoticonCollectionVC;
}

#pragma mark - HROPageControlDelegate

- (void)didSelectOptionForIndex:(NSInteger)index {
    [self scrollToViewControllerAtIndex:index];
}

@end
