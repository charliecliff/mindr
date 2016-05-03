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

@interface g5LocationConditionViewController () <MGLMapViewDelegate>

@property(nonatomic, strong) IBOutlet MGLMapView *mapView;

@end

@implementation g5LocationConditionViewController

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Location";
    
    [self setUpMapView];
    
    MGLPolygon *shape = [self polygonCircleForCoordinate:[g5LocationManager sharedManager].currentLocation.coordinate
                                         withMeterRadius:1000];
    [self.mapView addAnnotation:shape];
}

#pragma mark - Setup

- (void)setUpMapView {
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = 12;
    self.mapView.centerCoordinate = [g5LocationManager sharedManager].currentLocation.coordinate;
    self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/charliecliff/cin55wwd9000laanm199gv2gf"];
    self.mapView.delegate = self;
}

#pragma mark - MapBox

- (MGLPolygon*)polygonCircleForCoordinate:(CLLocationCoordinate2D)coordinate withMeterRadius:(double)meterRadius
{
    NSUInteger degreesBetweenPoints = 8; //45 sides
    NSUInteger numberOfPoints = floor(360 / degreesBetweenPoints);
    double distRadians = meterRadius / 6371000.0; // earth radius in meters
    double centerLatRadians = coordinate.latitude * M_PI / 180;
    double centerLonRadians = coordinate.longitude * M_PI / 180;
    CLLocationCoordinate2D coordinates[numberOfPoints]; //array to hold all the points
    for (NSUInteger index = 0; index < numberOfPoints; index++) {
        double degrees = index * degreesBetweenPoints;
        double degreeRadians = degrees * M_PI / 180;
        double pointLatRadians = asin( sin(centerLatRadians) * cos(distRadians) + cos(centerLatRadians) * sin(distRadians) * cos(degreeRadians));
        double pointLonRadians = centerLonRadians + atan2( sin(degreeRadians) * sin(distRadians) * cos(centerLatRadians),
                                                          cos(distRadians) - sin(centerLatRadians) * sin(pointLatRadians) );
        double pointLat = pointLatRadians * 180 / M_PI;
        double pointLon = pointLonRadians * 180 / M_PI;
        CLLocationCoordinate2D point = CLLocationCoordinate2DMake(pointLat, pointLon);
        coordinates[index] = point;
    }
    MGLPolygon *polygon = [MGLPolygon polygonWithCoordinates:coordinates count:numberOfPoints];
    return polygon;
}

- (CGFloat)mapView:(MGLMapView *)mapView alphaForShapeAnnotation:(MGLShape *)annotation
{
    // Set the alpha for shape annotations to 0.5 (half opacity)
    return 0.5f;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation
{
    // Set the stroke color for shape annotations
    return [UIColor whiteColor];
}

- (UIColor *)mapView:(MGLMapView *)mapView fillColorForPolygonAnnotation:(MGLPolygon *)annotation
{
    // Mapbox cyan fill color
    return [UIColor colorWithRed:59.0f/255.0f green:178.0f/255.0f blue:208.0f/255.0f alpha:1.0f];
}

@end
