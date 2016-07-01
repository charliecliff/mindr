//
//  MDRUserContext.m
//  g5Mindr
//
//  Created by Charles Cliff on 6/28/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "MDRUserContext.h"

NSString *const kMDRUserID   = @"user_id";

@implementation MDRUserContext

#pragma mark - Mantle Parsing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userID": kMDRUserID};
}

@end
