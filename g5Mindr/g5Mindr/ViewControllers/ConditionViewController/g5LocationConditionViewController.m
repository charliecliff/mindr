//
//  g5LocationConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationConditionViewController.h"
#import "MDRLocationManager.h"
#import "MDRLocationCondition.h"
#import "g5ConfigAndMacros.h"
#import "UIGestureRecognizer+Cancel.h"

@import Mapbox;
@import MapKit;

static NSString *const MDRLocationTitle             = @"LOCATION";
static NSString *const MDRLocationAnnotationTitle   = @"location";
static NSString *const MDRGrippyAnnotationTitle     = @"grippy";
static NSString *const MapBoxStyle = @"mapbox://styles/coopaloops/cimzpqej4000xahnmykdnml6k";

@interface g5LocationConditionViewController () <MGLMapViewDelegate> {
    BOOL shouldDragGrippyImage;
    double deltaLatitude;
    double deltaLongitude;
}

// PRIVATE
@property(nonatomic, strong) MGLPointAnnotation *locationAnnotation;
@property(nonatomic, strong) MGLPointAnnotation *grippyAnnotation;
@property(nonatomic, strong) MGLPolyline *radiusPoly;;
@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

// OUTLETS
@property(nonatomic, strong) IBOutlet UILabel *addressLabel;
@property(nonatomic, strong) IBOutlet MGLMapView *mapView;
@property(nonatomic, strong) IBOutlet UIView *mapOverlayView;

@end

@implementation g5LocationConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(MDRCondition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (self.condition == nil)
            self.condition = [[MDRLocationCondition alloc] init];
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMapView];
    [self setUpNavigationBar];
    [self refreshMap];
    [self updateLocationAddress];
}

#pragma mark - Setup

- (void)setUpMapView {
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = 12;
    self.mapView.centerCoordinate = ((MDRLocationCondition *)self.condition).location.coordinate;
    
    self.mapView.styleURL = [NSURL URLWithString:MapBoxStyle];
    
    
    self.mapView.delegate = self;
    
    shouldDragGrippyImage = NO;
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressMapView:)];
    [self.mapView addGestureRecognizer:self.longPressGesture];
    
    [self setUpAnnotations];
}

- (void)setUpAnnotations {
    // Location
    self.locationAnnotation = [[MGLPointAnnotation alloc] init];
    self.locationAnnotation.title = MDRLocationAnnotationTitle;
    [self.mapView addAnnotation:self.locationAnnotation];

    // Grippy
    CLLocationDegrees initialLatitude  = [self coordinateFromCoord:((MDRLocationCondition *)self.condition).location.coordinate
                                                      atDistanceKm:((MDRLocationCondition *)self.condition).radius/1000.0
                                                  atBearingDegrees:0.0].latitude;
    deltaLatitude  = initialLatitude - ((MDRLocationCondition *)self.condition).location.coordinate.latitude ;
    
    CLLocationDegrees initialLongitude = [self coordinateFromCoord:((MDRLocationCondition *)self.condition).location.coordinate
                                                      atDistanceKm:((MDRLocationCondition *)self.condition).radius/1000.0
                                                  atBearingDegrees:0.0].longitude;
    deltaLongitude = initialLongitude - ((MDRLocationCondition *)self.condition).location.coordinate.longitude ;
    
    self.grippyAnnotation = [[MGLPointAnnotation alloc] init];
    self.grippyAnnotation.title = MDRGrippyAnnotationTitle;
    [self.mapView addAnnotation:self.grippyAnnotation];

    // Circle
    self.radiusPoly = [self polygonCircleForCoordinate:((MDRLocationCondition *)self.condition).location.coordinate
                                       withMeterRadius:((MDRLocationCondition *)self.condition).radius];
    [self.mapView addAnnotation:self.radiusPoly];
}

- (void)setUpNavigationBar {
    self.navigationItem.title = MDRLocationTitle;
    self.navigationItem.hidesBackButton = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

#pragma mark - Dragging

- (void)didLongPressMapView:(UIGestureRecognizer *)gesture {
    CGPoint pointSelectedOnTheMapView = [gesture locationInView:self.mapView];
    if(gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint pointOfGrippyAnnotation = [self.mapView convertCoordinate:self.grippyAnnotation.coordinate toPointToView:self.mapView];
        CGFloat distance = hypotf(pointOfGrippyAnnotation.x - pointSelectedOnTheMapView.x, pointOfGrippyAnnotation.y - pointSelectedOnTheMapView.y);
        if (distance < 30) {
            shouldDragGrippyImage = YES;
            return;
        }
        [gesture cancel];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged && shouldDragGrippyImage)
            [self updateGrippyAnnotationToPointInMapView:pointSelectedOnTheMapView];
    else if(gesture.state == UIGestureRecognizerStateEnded)
        shouldDragGrippyImage = NO;
}

- (void)updateGrippyAnnotationToPointInMapView:(CGPoint)pointInMapView {
    CLLocationCoordinate2D coord = [self.mapView convertPoint:pointInMapView toCoordinateFromView:self.mapView];
    CLLocation *newGrippyLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    deltaLatitude  = coord.latitude - ((MDRLocationCondition *)self.condition).location.coordinate.latitude;
    deltaLongitude = coord.longitude - ((MDRLocationCondition *)self.condition).location.coordinate.longitude;

    CLLocationDistance distance = [newGrippyLocation distanceFromLocation:((MDRLocationCondition *)self.condition).location];
    ((MDRLocationCondition *)self.condition).radius = distance;
    
    [self refreshMap];
}

- (void)updateLocationAddress {
    __weak g5LocationConditionViewController *weakSelf = self;
    [[MDRLocationManager sharedManager] getAddressForLocation:((MDRLocationCondition *)self.condition).location
                                                 withSuccess:^(NSString *addressLine) {
                                                     g5LocationConditionViewController *strongSelf = weakSelf;
                                                     ((MDRLocationCondition *)strongSelf.condition).address = addressLine;
                                                     [strongSelf refreshAddressLabel];
                                                 }
                                                 withFailure:nil];
}

#pragma mark - Refresh

- (void)refreshMap {
    self.locationAnnotation.coordinate  = ((MDRLocationCondition *)self.condition).location.coordinate;
    self.grippyAnnotation.coordinate    = CLLocationCoordinate2DMake(self.locationAnnotation.coordinate.latitude  + deltaLatitude,
                                                                     self.locationAnnotation.coordinate.longitude + deltaLongitude);
    if (self.radiusPoly)
        [self.mapView removeAnnotation:self.radiusPoly];
    self.radiusPoly = [self polygonCircleForCoordinate:((MDRLocationCondition *)self.condition).location.coordinate
                                       withMeterRadius:((MDRLocationCondition *)self.condition).radius];
    [self.mapView addAnnotation:self.radiusPoly];
}

- (void)refreshAddressLabel {
    if ( ((MDRLocationCondition *)self.condition).location != nil ) {
        CLLocationDistance distanceInMiles = ((MDRLocationCondition *)self.condition).radius * 0.000621371;
        NSString *addressString = ((MDRLocationCondition *)self.condition).address;
        
        NSString *string = [NSString stringWithFormat:@"%0.1f m from %@", distanceInMiles, addressString];
        NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] initWithString:string];
        [labelString addAttribute:NSForegroundColorAttributeName
                            value:self.normalTextColor
                            range:NSMakeRange(0, labelString.length-1)];
        
        NSRange range = [string rangeOfString:@"from"];
        [labelString addAttribute:NSForegroundColorAttributeName value:self.highlightedColor range:range];
        self.addressLabel.attributedText = labelString;
    }
}

#pragma mark - Polyine Construction

- (MGLPolyline*)polygonCircleForCoordinate:(CLLocationCoordinate2D)coordinate withMeterRadius:(double)meterRadius {
    NSUInteger degreesBetweenPoints = 4; //45 sides
    NSUInteger numberOfPoints = floor(360 / degreesBetweenPoints) + 1;
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
    MGLPolyline *polygon = [MGLPolyline polylineWithCoordinates:coordinates count:numberOfPoints];
    return polygon;
}

#pragma mark - Map Math

- (double)radiansFromDegrees:(double)degrees {
    return degrees * (M_PI/180.0);
}

- (double)degreesFromRadians:(double)radians {
    return radians * (180.0/M_PI);
}

- (CLLocationCoordinate2D)coordinateFromCoord:(CLLocationCoordinate2D)fromCoord atDistanceKm:(double)distanceKm atBearingDegrees:(double)bearingDegrees {
    double distanceRadians = distanceKm / 6371.0;
    //6,371 = Earth's radius in km
    double bearingRadians = [self radiansFromDegrees:bearingDegrees];
    double fromLatRadians = [self radiansFromDegrees:fromCoord.latitude];
    double fromLonRadians = [self radiansFromDegrees:fromCoord.longitude];
    
    double toLatRadians = asin( sin(fromLatRadians) * cos(distanceRadians)
                               + cos(fromLatRadians) * sin(distanceRadians) * cos(bearingRadians) );
    
    double toLonRadians = fromLonRadians + atan2(sin(bearingRadians)
                                                 * sin(distanceRadians) * cos(fromLatRadians), cos(distanceRadians)
                                                 - sin(fromLatRadians) * sin(toLatRadians));
    
    // adjust toLonRadians to be in the range -180 to +180...
    toLonRadians = fmod((toLonRadians + 3*M_PI), (2*M_PI)) - M_PI;
    
    CLLocationCoordinate2D result;
    result.latitude = [self degreesFromRadians:toLatRadians];
    result.longitude = [self degreesFromRadians:toLonRadians];
    return result;
}

#pragma mark - MGLMapViewDelegate

- (CGFloat)mapView:(MGLMapView *)mapView lineWidthForPolylineAnnotation:(MGLPolyline *)annotation {
    return 4;
}

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return [UIColor whiteColor];
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:annotation.title];
    if ( !annotationImage ) {
        UIImage *image;
        if ([annotation.title isEqualToString:MDRLocationAnnotationTitle])
            image = [UIImage imageNamed:@"location_annotation"];
        else if ([annotation.title isEqualToString:MDRGrippyAnnotationTitle])
            image = [UIImage imageNamed:@"grippy_annotation"];
        else
            assert(false);
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:annotation.title];
    }
    return annotationImage;
}

- (void)mapViewRegionIsChanging:(nonnull MGLMapView *)mapView {
    ((MDRLocationCondition *)self.condition).location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude
                                                                                   longitude:mapView.centerCoordinate.longitude ];
    [self refreshMap];
}

- (void)mapView:(MGLMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self updateLocationAddress];
}

@end
