//
//  g5LocationMonitor.h
//  g5Mindr
//
//  Created by Charles Cliff on 5/30/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface g5LocationMonitor : NSObject

- (CLLocation *)currentLocation;

@end
