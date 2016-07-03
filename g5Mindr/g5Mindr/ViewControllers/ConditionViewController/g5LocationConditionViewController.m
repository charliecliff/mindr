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

static NSString *const MDRLocationTitle = @"LOCATION";
static NSString *const MDRLocationAnnotationTitle   = @"location";
static NSString *const MDRGrippyAnnotationTitle     = @"grippy";

@interface g5LocationConditionViewController () <MGLMapViewDelegate> {
    BOOL shouldDragLocationImage;
    BOOL shouldDragGrippyImage;
}

@property(nonatomic, strong) IBOutlet UILabel *addressLabel;
@property(nonatomic, strong) IBOutlet MGLMapView *mapView;
@property(nonatomic, strong) IBOutlet UIView *mapOverlayView;

@property(nonatomic, strong) MGLPointAnnotation *locationAnnotation;
@property(nonatomic, strong) MGLPointAnnotation *grippyAnnotation;
@property(nonatomic, strong) MGLPolyline *radiusPoly;;

@property(nonatomic, strong) CLLocation *grippyLocation;

@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation g5LocationConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(MDRCondition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (self.condition == nil) {
            self.condition = [[MDRLocationCondition alloc] init];
        }
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
    self.mapView.styleURL = [NSURL URLWithString:@"mapbox://styles/charliecliff/cin55wwd9000laanm199gv2gf"];
    self.mapView.delegate = self;
    
    shouldDragLocationImage = NO;
    shouldDragGrippyImage = NO;
    
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressMapView:)];
    [self.mapView addGestureRecognizer:self.longPressGesture];
}

- (void)setUpNavigationBar {
    self.navigationItem.title = MDRLocationTitle;
    self.navigationItem.hidesBackButton = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

#pragma mark - Actions

- (void)didLongPressMapView:(UIGestureRecognizer *)gesture {
    CGPoint pointSelectedOnTheMapView = [gesture locationInView:self.mapView];

    if(gesture.state == UIGestureRecognizerStateBegan) {
        
        if (self.locationAnnotation == nil) {
            [self addAnnotationAtPointInMapView:pointSelectedOnTheMapView];
            return;
        }
        
        CGFloat distance;

        CGPoint pointOfGrippyAnnotation = [self.mapView convertCoordinate:self.grippyAnnotation.coordinate toPointToView:self.mapView];
        distance = hypotf(pointOfGrippyAnnotation.x - pointSelectedOnTheMapView.x, pointOfGrippyAnnotation.y - pointSelectedOnTheMapView.y);
        if (distance < 30) {
            shouldDragGrippyImage = YES;
            return;
        }
        
        CGPoint pointOfLocationAnnotation = [self.mapView convertCoordinate:self.locationAnnotation.coordinate toPointToView:self.mapView];
        distance = hypotf(pointOfLocationAnnotation.x - pointSelectedOnTheMapView.x, pointOfLocationAnnotation.y - pointSelectedOnTheMapView.y);
        if (distance < 30) {
            return;
            shouldDragLocationImage = YES;
            return;
        }
        
        [self addAnnotationAtPointInMapView:pointSelectedOnTheMapView];
        [gesture cancel];
    }
    else if(gesture.state == UIGestureRecognizerStateChanged) {
        
        if (shouldDragGrippyImage) {
            [self updateGrippyAnnotationToPointInMapView:pointSelectedOnTheMapView];
        }
        if (shouldDragLocationImage) {
            [self updateLocationAnnotationToPointInMapView:pointSelectedOnTheMapView];
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded) {
        shouldDragGrippyImage = NO;
        shouldDragLocationImage = NO;
    }
}

#pragma mark - Dragging

- (void)addAnnotationAtPointInMapView:(CGPoint)pointInMapView {
    //  1. Point for the Location
    CLLocationCoordinate2D coord = [self.mapView convertPoint:pointInMapView toCoordinateFromView:self.mapView];
    ((MDRLocationCondition *)self.condition).location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    //  2. Point for the Grippy
    CGPoint pontForGrippy = CGPointMake(pointInMapView.x, pointInMapView.y + 100);
    CLLocationCoordinate2D coordinateForGrippy = [self.mapView convertPoint:pontForGrippy toCoordinateFromView:self.mapView];
    self.grippyLocation = [[CLLocation alloc] initWithLatitude:coordinateForGrippy.latitude longitude:coordinateForGrippy.longitude];
    
    CLLocationDistance distance = [self.grippyLocation distanceFromLocation:((MDRLocationCondition *)self.condition).location];
    ((MDRLocationCondition *)self.condition).radius = distance;
    
    //  3. Refresh
    [self updateLocationAddress];
    [self refreshMap];
}

- (void)updateLocationAnnotationToPointInMapView:(CGPoint)pointInMapView {
    CLLocationCoordinate2D coord = [self.mapView convertPoint:pointInMapView toCoordinateFromView:self.mapView];
    ((MDRLocationCondition *)self.condition).location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [self.grippyLocation distanceFromLocation:((MDRLocationCondition *)self.condition).location];
    ((MDRLocationCondition *)self.condition).radius = distance;
    
    [self updateLocationAddress];
    [self refreshMap];
}

- (void)updateGrippyAnnotationToPointInMapView:(CGPoint)pointInMapView {
    CLLocationCoordinate2D coord = [self.mapView convertPoint:pointInMapView toCoordinateFromView:self.mapView];
    self.grippyLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [self.grippyLocation distanceFromLocation:((MDRLocationCondition *)self.condition).location];
    ((MDRLocationCondition *)self.condition).radius = distance;
    
    [self refreshAddressLabel];
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
    if ( ((MDRLocationCondition *)self.condition).location != nil ) {
        if (self.locationAnnotation) {
            [self.mapView removeAnnotation:self.locationAnnotation];
        }
        self.locationAnnotation = [[MGLPointAnnotation alloc] init];
        self.locationAnnotation.coordinate = ((MDRLocationCondition *)self.condition).location.coordinate;
        self.locationAnnotation.title = MDRLocationAnnotationTitle;
        [self.mapView addAnnotation:self.locationAnnotation];
    }
    
    if ( self.grippyLocation != nil ) {
        if (self.grippyAnnotation) {
            [self.mapView removeAnnotation:self.grippyAnnotation];
        }
        self.grippyAnnotation = [[MGLPointAnnotation alloc] init];
        self.grippyAnnotation.coordinate = self.grippyLocation.coordinate;
        self.grippyAnnotation.title = MDRGrippyAnnotationTitle;
        [self.mapView addAnnotation:self.grippyAnnotation];
    }
    
    if ( ((MDRLocationCondition *)self.condition).radius != 0 ) {
        if (self.radiusPoly) {
            [self.mapView removeAnnotation:self.radiusPoly];
        }
        self.radiusPoly = [self polygonCircleForCoordinate:((MDRLocationCondition *)self.condition).location.coordinate
                                              withMeterRadius:((MDRLocationCondition *)self.condition).radius];
        [self.mapView addAnnotation:self.radiusPoly];
    }
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

        [labelString addAttribute:NSForegroundColorAttributeName
                      value:self.highlightedColor
                      range:range];
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

#pragma mark - MGLMapViewDelegate

- (UIColor *)mapView:(MGLMapView *)mapView strokeColorForShapeAnnotation:(MGLShape *)annotation {
    return self.regionBorderColor;
}

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation {

    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:annotation.title];
    
    if ( ! annotationImage) {
        UIImage *image;
        if ([annotation.title isEqualToString:MDRLocationAnnotationTitle]) {
            image = [UIImage imageNamed:@"location_annotation"];
        }
        else if ([annotation.title isEqualToString:MDRGrippyAnnotationTitle]) {
            image = [UIImage imageNamed:@"grippy_annotation"];
        }
        else {
            assert(false);
        }
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:annotation.title];
    }
    
    return annotationImage;
}

@end
