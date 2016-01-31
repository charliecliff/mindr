//
//  g5MenuSourceAsset.m
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5MenuSourceAsset.h"
#import "g5ReminderMenu.h"

@implementation g5MenuSourceAsset

- (NSDictionary *)getReminderMenus {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"menus" ofType:@"plist"];
    NSDictionary *menuDataDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSMutableDictionary *reminderMenuDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *menuID in menuDataDictionary.allKeys) {
        NSDictionary *menuData = [menuDataDictionary objectForKey:menuID];
        g5ReminderMenu *newMenu = [[g5ReminderMenu alloc] initWithDictionary:menuData];
        [reminderMenuDictionary setObject:newMenu forKey:menuID];
    }
    
    return reminderMenuDictionary;
}

@end
