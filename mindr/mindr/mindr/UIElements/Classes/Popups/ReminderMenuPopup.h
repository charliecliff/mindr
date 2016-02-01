//
//  gsMenuPopup.h
//  GSTicket
//
//  Created by Charles Cliff on 1/27/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "LivePopup.h"
#import "g5ReminderMenu.h"

@protocol MenuPopupDelegate <NSObject>

@required
- (void)didSelectReminderPhrase:(NSString *)reminderPhrase;
- (void)didSelectNextMenuWithID:(NSString *)nextMenuID;

@end

@interface ReminderMenuPopup : LivePopup

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) id<MenuPopupDelegate>delegate;

- (void)configureForMenu:(g5ReminderMenu *)menu;

@end
