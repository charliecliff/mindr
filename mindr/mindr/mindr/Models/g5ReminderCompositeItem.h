//
//  g5ReminderCompositeItem.h
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface g5ReminderCompositeItem : NSObject

@property(nonatomic, strong) NSString *menu_id;
@property(nonatomic, strong) NSString *displayPhrase;

- (g5ReminderCompositeItem *)initWithDictionary:(NSDictionary *)dictionary;

@end
