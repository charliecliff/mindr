#import "MDREmoticonSelectionViewController.h"
#import "MDRReminderTitleViewController.h"
#import "MDREmoticonCollectionViewController.h"
#import "g5EmoticonCell.h"
#import "HROPageControl.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"
#import <PBJHexagonFlowLayout.h>

static NSString *const MDRSelectEmoticonTitle = @"Choose an Emoticon";
static NSString *const MDREmbedEmoticonPageViewController = @"embed_emoticon_page_view_controller";

@interface MDREmoticonSelectionViewController () <HROPageControlDelegate>

// PRIVATE
@property(nonatomic, strong) NSArray *emoticonImageNames;

// BINDING
@property(nonatomic, weak) IBOutlet HROPageControl *pageControl;

@end

@implementation MDREmoticonSelectionViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSArray *iconArray = [NSArray arrayWithObjects:image1, image2, image3, nil];
    self.pageControl.icons = iconArray;
    
    [self.pageControl setSelectedIconAtIndex:1];
}

#pragma mark - Segue

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:MDREmbedEmoticonPageViewController]) {
         UIPageViewController *emoticonPageVC = (UIPageViewController *)segue.destinationViewController;
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MDREmoticonSelection" bundle:[NSBundle mainBundle]];
         MDREmoticonCollectionViewController *emoticonCollectionVC = [storyboard instantiateViewControllerWithIdentifier:@"collection_vc"];

         NSArray *viewControllers = @[emoticonCollectionVC];
         [emoticonPageVC setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

         NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emoticons" ofType:@"plist"];
         NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
         emoticonCollectionVC.emoticonUnicodeCharacters = [plistDictionary objectForKey:@"emoticons"];
    }
 }

#pragma mark - HROPageControlDelegate

- (void)didSelectOptionForIndex:(NSInteger)index {
    [self.pageControl setSelectedIconAtIndex:index];
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
