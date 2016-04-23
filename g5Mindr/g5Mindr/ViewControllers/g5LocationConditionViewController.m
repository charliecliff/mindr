//
//  g5LocationConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationConditionViewController.h"
#import "g5LocationManager.h"

@import Mapbox;

@interface g5LocationConditionViewController ()

@property(nonatomic, strong) IBOutlet MGLMapView *mapView;

@end

@implementation g5LocationConditionViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMapView];
}

#pragma mark - Setup

- (void)setUpMapView {
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = 14;
    self.mapView.centerCoordinate = [g5LocationManager sharedManager].currentLocation.coordinate;
    self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/charliecliff/cin55wwd9000laanm199gv2gf"];
}

@end
