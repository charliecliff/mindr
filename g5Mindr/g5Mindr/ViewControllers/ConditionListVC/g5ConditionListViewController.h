#import <UIKit/UIKit.h>
#import "mindrBounceNavigationViewController.h"
#import "MDRReminder.h"
#import "g5ConfigAndMacros.h"

@protocol g5ConditionListViewControllerDelegate <NSObject>

@required
- (void)didSelectConditionCell;

@end

@interface g5ConditionListViewController : UITableViewController <HROBounceNavigationDelegate>

@property(nonatomic, strong) MDRReminder *reminder;
@property(nonatomic, strong) id<g5ConditionListViewControllerDelegate> delegate;

@property(nonatomic, weak) mindrBounceNavigationViewController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(MDRReminder *)reminder;

@end
