//
//  g5CalendarHeaderView.h
//  g5Mindr
//
//  Created by Charles Cliff on 4/12/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "g5CalendarProtocols.h"

@interface g5CalendarHeaderView : UIView

@property (nonatomic, strong) id<g5CalendarRowDatasource> datasource;

- (void)configureForFirstDayOfMonth:(NSDate *)firstDayOftheMonth;

@end
