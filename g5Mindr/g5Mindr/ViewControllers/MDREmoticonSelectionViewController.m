#import "MDREmoticonSelectionViewController.h"
#import "MDRReminderTitleViewController.h"
#import "MDREmoticonCollectionViewController.h"
#import "g5EmoticonCell.h"
#import "HROPageControl.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import <PBJHexagonFlowLayout.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static NSString *const MDRSelectEmoticonTitle = @"Choose an Emoticon";
static NSString *const MDREmbedEmoticonPageViewController = @"embed_emoticon_page_view_controller";

@interface MDREmoticonSelectionViewController () <HROPageControlDelegate, UIPageViewControllerDataSource>

// PRIVATE
@property(nonatomic) NSInteger selectedPageIndex;
@property(nonatomic, strong) NSArray *emoticonImageNames;
@property(nonatomic, strong) NSArray * orderedViewControllers;
@property(nonatomic, strong) UIPageViewController *emoticonPageVC;

// BINDING
@property(nonatomic, weak) IBOutlet HROPageControl *pageControl;

@end

@implementation MDREmoticonSelectionViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedPageIndex =0;
    
    self.orderedViewControllers = @[[self collectionViewForEmoticonSet:@"emoticons"],
                                    [self collectionViewForEmoticonSet:@"emoticons"],
                                    [self collectionViewForEmoticonSet:@"emoticons"],
                                    [self collectionViewForEmoticonSet:@"emoticons"],
                                    [self collectionViewForEmoticonSet:@"emoticons"],
                                    [self collectionViewForEmoticonSet:@"emoticons"]];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.navigationItem.title = MDRSelectEmoticonTitle;
    self.navigationItem.hidesBackButton = YES;
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    progressLabel.text = @"2/3";
    progressLabel.textColor = [UIColor colorWithRed:138.0/255.0 green:183.0/255.0 blue:230.0/255.0 alpha:1];
    progressLabel.font = [UIFont fontWithName:@"ProximaNovaSoftW03-Bold" size:18.0f];
    [barView addSubview:progressLabel];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:barView];
    self.navigationItem.leftBarButtonItem = barBtn;
    
    
    [self setUpPageControl];
    [self scrollToViewControllerAtIndex:self.selectedPageIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.bounceNavigationController.delegate = self;
    [self reload];
}

- (void)reload {
    if ([self.reminder hasEmoticon]) {
        [self.bounceNavigationController setRightButtonEnabled:YES];
    }
    else {
        [self.bounceNavigationController setRightButtonEnabled:NO];
    }
}

#pragma mark - Set Up

- (void)setUpEmoticonImageNames {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    self.emoticonImageNames = [plistDictionary objectForKey:@"emoticons"];
}

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

#pragma mark - Segue

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:MDREmbedEmoticonPageViewController]) {
         MDREmoticonCollectionViewController *emoticonCollectionVC = [self collectionViewForEmoticonSet:@"emoticons"];
         self.emoticonPageVC = (UIPageViewController *)segue.destinationViewController;
         [self.emoticonPageVC setViewControllers:@[emoticonCollectionVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
         self.emoticonPageVC.doubleSided = NO;
         self.emoticonPageVC.dataSource = self;
         self.emoticonPageVC.delegate = self;
    }
}

#pragma mark - Helpers

- (MDREmoticonCollectionViewController *)collectionViewForEmoticonSet:(NSString *)emoticonSetName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MDREmoticonSelection" bundle:[NSBundle mainBundle]];
    MDREmoticonCollectionViewController *emoticonCollectionVC = [storyboard instantiateViewControllerWithIdentifier:@"collection_vc"];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    emoticonCollectionVC.emoticonUnicodeCharacters = [plistDictionary objectForKey:emoticonSetName];
    
    emoticonCollectionVC.reminder = self.reminder;
    
    return emoticonCollectionVC;
}

- (void)scrollToViewControllerAtIndex:(NSInteger)index {
    UIViewController *currentViewController = ((NSArray *)[self orderedViewControllers])[index];
    [self.emoticonPageVC setViewControllers:@[currentViewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    [self updateForDisplayedViewController:currentViewController];
}

- (void)updateForDisplayedViewController:(UIViewController *)viewController {
    self.selectedPageIndex = [self.orderedViewControllers indexOfObject:viewController];
    [self.pageControl setSelectedIconAtIndex:self.selectedPageIndex];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        [self updateForDisplayedViewController:[self.emoticonPageVC.viewControllers firstObject]];
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

#pragma mark - g5BounceNavigationDelegate

- (void)didPressCenterButton {
    assert(false);
}

- (void)didPressPreviousButton {
    [self.bounceNavigationController.navigationController popViewControllerAnimated:YES];
}

- (void)didPressNextButton {
    MDRReminderTitleViewController *vc = [[MDRReminderTitleViewController alloc] initWithReminder:self.reminder];
    vc.bounceNavigationController = self.bounceNavigationController;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didPressCancelButton {
    [self.bounceNavigationController.navigationController popToRootViewControllerAnimated:YES];
}

@end
