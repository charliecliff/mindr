//
//  g5ReminderMenu.h
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderCompositeItem.h"

@interface g5ReminderMenu : g5ReminderCompositeItem

@property(nonatomic, strong) NSString *type;
@property(nonatomic, strong) NSArray *childrenReminderItems;

- (g5ReminderMenu *)initWithDictionary:(NSDictionary *)dictionary;

- (NSString *)reminderPhraseForSelectedIdnex:(NSInteger)selectedIndex;

@end
