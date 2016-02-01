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

@interface ViewController () <MenuPopupDelegate>

@property(nonatomic, strong) NSDictionary *menus;
@property(nonatomic, strong) ReminderMenuPopup *popup;

@end

@implementation ViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    
    self.menus = [self.menuSource getReminderMenus];
    
    self.popup = [[ReminderMenuPopup alloc] init];
    [self.popup configureForMenu:[self.menus objectForKey:@"base"]];
    [self.popup setDelegate:self];
    [self.popup present];
}

#pragma mark - MenuPopupDelegate

- (void)didSelectReminderPhrase:(NSString *)reminderPhrase {
    
}

- (void)didSelectNextMenuWithID:(NSString *)nextMenuID {
    [self.popup dismiss];
    
    g5ReminderMenu *nextMenu = [self.menus objectForKey:nextMenuID];
    
    self.popup = [[ReminderMenuPopup alloc] init];
    [self.popup configureForMenu:nextMenu];
    [self.popup setDelegate:self];
    [self.popup present];
}

@end
