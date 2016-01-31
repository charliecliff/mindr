//
//  g5ReminderElement.h
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface g5ReminderElement : NSObject

@property(nonatomic, strong) NSString *tid;
@property(nonatomic, strong) NSString *displayDescription;

@property(nonatomic, strong) NSArray *childrenReminderItems;

@end
