//
//  ViewController.h
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5MenuSource.h"

@interface ViewController : UIViewController

@property(nonatomic, strong) id<g5MenuSource> menuSource;

@end

