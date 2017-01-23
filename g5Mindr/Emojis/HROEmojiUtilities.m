//
//  HROEmojiUtilities.m
//  g5Mindr
//
//  Created by Charles Cliff on 11/17/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "HROEmojiUtilities.h"

@implementation HROEmojiUtilities

+(NSString *)smallImageNameForEmoji:(NSString *)emoji {

  NSString *emojiFileName = [emoji lowercaseString];
  emojiFileName = [NSString stringWithFormat:@"%@ small", emojiFileName];
  return emojiFileName;
}

+(NSString *)largeImageNameForEmoji:(NSString *)emoji {
  
  NSString *emojiFileName = [emoji lowercaseString];
  emojiFileName = [NSString stringWithFormat:@"%@ large", emojiFileName];
  return emojiFileName;
}

@end
