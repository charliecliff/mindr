//
//  g5ReminderMenu.m
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderMenu.h"
#import "g5ReminderElement.h"

#define KEY_TYPE @"type"
#define KEY_MENU_OPTIONS @"menu_options"

@implementation g5ReminderMenu

- (g5ReminderMenu *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if (self != nil) {
        self.type = [dictionary objectForKey:KEY_TYPE];
        
        NSMutableArray *tmp = [[NSMutableArray alloc] init];
        
        NSArray *arrayOfReminderElements = [dictionary objectForKey:KEY_MENU_OPTIONS];
        for (NSDictionary *reminderElementDictionary in arrayOfReminderElements) {
            g5ReminderElement *newElement = [[g5ReminderElement alloc] initWithDictionary:reminderElementDictionary];
            [tmp addObject:newElement];
        }
        
        self.childrenReminderItems = [NSArray arrayWithArray:tmp];
    }
    return self;
}

@end
