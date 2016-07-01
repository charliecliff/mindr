//
//  MDRUserContext.h
//  g5Mindr
//
//  Created by Charles Cliff on 6/28/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Mantle/Mantle.h>

@class CLLocation;

@interface MDRUserContext : MTLModel <MTLJSONSerializing>

@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) CLLocation *currentLocation;

@end
