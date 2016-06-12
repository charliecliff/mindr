//
//  UIGestureRecognizer+Cancel.m
//  g5Mindr
//
//  Created by Charles Cliff on 6/11/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "UIGestureRecognizer+Cancel.h"

@implementation UIGestureRecognizer (Cancel)

- (void)cancel {
    self.enabled = NO;
    self.enabled = YES;
}

@end

