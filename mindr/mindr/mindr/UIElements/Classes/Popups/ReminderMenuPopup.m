//
//  gsMenuPopup.m
//  GSTicket
//
//  Created by Charles Cliff on 1/27/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "ReminderMenuPopup.h"
#import "g5ReminderElement.h"

@interface ReminderMenuPopup ()

@property (nonatomic, strong) g5ReminderMenu *menu;

@property(nonatomic, strong) IBOutlet UITableView *menuOptionTableView;

@end

@implementation ReminderMenuPopup

- (instancetype)init {
    self = [super init];
    if (self) {
        return self;
    }
    return nil;
}

- (void)configureForMenu:(g5ReminderMenu *)menu {
    self.menu = menu;
    CGFloat newPopupHeight = self.menu.childrenReminderItems.count * 40 + 44;
    self.contentViewHeight = newPopupHeight;
    [self.menuOptionTableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menu.childrenReminderItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    g5ReminderElement *element = [self.menu.childrenReminderItems objectAtIndex:indexPath.row];
    [cell.textLabel setText:element.displayPhrase];
    
    return cell;
}

@end
