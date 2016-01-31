//
//  ViewController.m
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "ViewController.h"
#import "ReminderMenuPopup.h"
#import "g5ReminderFactory.h"

@interface ViewController ()

@property(nonatomic, strong) NSDictionary *menus;

@end

@implementation ViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    self.menus = [self.menuSource getReminderMenus];
    
    
    
    ReminderMenuPopup *popup = [[ReminderMenuPopup alloc] init];
    [popup configureForMenu:[self.menus objectForKey:@"base"]];
    [popup present];
}

@end
