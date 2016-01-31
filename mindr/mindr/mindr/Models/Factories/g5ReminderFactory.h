//
//  g5ReminderFactory.h
//  mindr
//
//  Created by Charles Cliff on 1/31/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface g5ReminderFactory : NSObject

@property(nonatomic, strong, readonly) NSString *reminderPhrase;

-(void)addReminderPhrase:(NSString *)phrase;

- (NSString *)generate;

@end
