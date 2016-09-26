//
//  MDRUserContext.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface MDRUserContext : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) CLLocation *currentLocation;

- (NSDictionary *)encodeToDictionary;

@end
