//
//  g5ReminderFactory.m
//  mindr
//
//  Created by Charles Cliff on 1/31/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5ReminderFactory.h"

@interface g5ReminderFactory ()

@property(nonatomic, strong, readwrite) NSString *reminderPhrase;

@end

@implementation g5ReminderFactory

-(void)addReminderPhrase:(NSString *)phrase {
    self.reminderPhrase = [NSString stringWithFormat:@"%@ %@", self.reminderPhrase, phrase];
}

- (NSString *)generate {
    return self.reminderPhrase;
}

@end

