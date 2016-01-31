//
//  g5ReminderCompositeItem.m
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderCompositeItem.h"

#define KEY_PHRASE @"display_phrase"
#define KEY_NEXT_MENU_UD @"menu_id"

@implementation g5ReminderCompositeItem

- (g5ReminderCompositeItem *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self != nil) {
        self.displayPhrase = [dictionary objectForKey:KEY_PHRASE];
        self.menu_id = [dictionary objectForKey:KEY_NEXT_MENU_UD];
    }
    return self;
}

@end
