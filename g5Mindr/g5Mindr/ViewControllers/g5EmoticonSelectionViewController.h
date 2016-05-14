//
//  g5EmoticonSelectionViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/22/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5BounceNavigationController.h"

@class g5Reminder;

@interface g5EmoticonSelectionViewController : UIViewController <g5BounceNavigationDelegate>

@property(nonatomic, strong) g5Reminder *reminder;

@property(nonatomic, weak) g5BounceNavigationController *bounceNavigationController;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithReminder:(g5Reminder *)reminder;

@end
