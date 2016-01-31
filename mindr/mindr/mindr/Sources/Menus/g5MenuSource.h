//
//  g5MenuSource.h
//  mindr
//
//  Created by Charles Cliff on 1/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol g5MenuSource <NSObject>

@required
- (NSDictionary *)getReminderMenus;

@end

