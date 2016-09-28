//
//  mindrBounceNavigationViewController.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "HROBounceNavigationController.h"

@interface mindrBounceNavigationViewController : HROBounceNavigationController <HROBounceNavigationDatasource>

@property (nonatomic) BOOL shouldShowTrashCanOnBounceButton;
@property (nonatomic) BOOL shouldShowCheckMarkOnRightButton;

@end
