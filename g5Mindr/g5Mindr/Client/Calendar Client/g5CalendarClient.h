//
//  g5CalendarSource.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/19/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol g5CalendarClient <NSObject>

- (CLLocation *)currentLocation;

@end
