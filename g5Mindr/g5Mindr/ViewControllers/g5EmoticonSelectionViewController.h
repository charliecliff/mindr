//
//  g5EmoticonSelectionViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HROPageControl.h"
#import "HROBounceNavigationController.h"

@class MDRReminder;

@interface g5EmoticonSelectionViewController : UIViewController <HROBounceNavigationDelegate>

@property(nonatomic, strong) MDRReminder *reminder;

@property(nonatomic, weak) HROBounceNavigationController *bounceNavigationController;

@property(nonatomic, weak) IBOutlet HROPageControl *pageControl;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(MDRReminder *)reminder;

@end
