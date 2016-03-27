//
//  g5LocationSource.h
//  g5Mindr
//
//  Created by Charles Cliff on 3/21/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol g5LocationDatasource <NSObject>

@required
- (CLLocation *)currentLocation;

@end
