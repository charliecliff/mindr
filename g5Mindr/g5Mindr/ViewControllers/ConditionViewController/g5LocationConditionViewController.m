//
//  g5LocationConditionViewController.m
//  g5Mindr
//
//  Created by Charles Cliff on 3/23/16.
//  Copyright © 2016 Charles Cliff. All rights reserved.
//

#import "g5LocationConditionViewController.h"
#import "g5LocationManager.h"
#import "g5LocationCondition.h"
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
@property(nonatomic, strong) MGLShape *radiusPolygon;

@property(nonatomic, strong) CLLocation *grippyLocation;

@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@end

@implementation g5LocationConditionViewController

#pragma mark - Init

- (instancetype)initWithCondition:(g5Condition *)condition {
    self = [super initWithCondition:condition];
    if (self != nil) {
        if (self.condition == nil) {
            self.condition = [[g5LocationCondition alloc] init];
        }
    }
    return self;
}

#pragma mark - View Life-Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpMapView];
    [self setUpNavigationBar];
    [self refresh];
}

#pragma mark - Setup

- (void)setUpMapView {
    self.mapView.showsUserLocation = NO;
    self.mapView.zoomLevel = 12;
    self.mapView.centerCoordinate = [g5LocationManager sharedManager].currentLocation.coordinate;
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
    ((g5LocationCondition *)self.condition).location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    //  2. Point for the Grippy
    CGPoint pontForGrippy = CGPointMake(pointInMapView.x, pointInMapView.y + 100);
    CLLocationCoordinate2D coordinateForGrippy = [self.mapView convertPoint:pontForGrippy toCoordinateFromView:self.mapView];
    self.grippyLocation = [[CLLocation alloc] initWithLatitude:coordinateForGrippy.latitude longitude:coordinateForGrippy.longitude];
    
    CLLocationDistance distance = [self.grippyLocation distanceFromLocation:((g5LocationCondition *)self.condition).location];
    ((g5LocationCondition *)self.condition).radius = distance;
    
    //  3. The Address
    __weak g5LocationConditionViewController *weakSelf = self;
    [[g5LocationManager sharedManager] getAddressForLocation:((g5LocationCondition *)self.condition).location
                                                 withSuccess:^(NSString *addressLine) {
                                                     g5LocationConditionViewController *strongSelf = weakSelf;
                                                     ((g5LocationCondition *)strongSelf.condition).address = addressLine;
                                                     [strongSelf refresh];
                                                 }
                                                 withFailure:nil];
    //  4. Refresh
    [self refresh];
}

- (void)updateLocationAnnotationToPointInMapView:(CGPoint)pointInMapView {
    CLLocationCoordinate2D coord = [self.mapView convertPoint:pointInMapView toCoordinateFromView:self.mapView];
    ((g5LocationCondition *)self.condition).location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [self.grippyLocation distanceFromLocation:((g5LocationCondition *)self.condition).location];
    ((g5LocationCondition *)self.condition).radius = distance;
    
    [self refresh];
}

- (void)updateGrippyAnnotationToPointInMapView:(CGPoint)pointInMapView {
    CLLocationCoordinate2D coord = [self.mapView convertPoint:pointInMapView toCoordinateFromView:self.mapView];
    self.grippyLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLLocationDistance distance = [self.grippyLocation distanceFromLocation:((g5LocationCondition *)self.condition).location];
    ((g5LocationCondition *)self.condition).radius = distance;
    
    [self refresh];
}

#pragma mark - Refresh

- (void)refresh {
    [self refreshMap];
    [self refreshAddressLabel];
}

- (void)refreshMap {
    if ( ((g5LocationCondition *)self.condition).location != nil ) {
        if (self.locationAnnotation) {
            [self.mapView removeAnnotation:self.locationAnnotation];
        }
        self.locationAnnotation = [[MGLPointAnnotation alloc] init];
        self.locationAnnotation.coordinate = ((g5LocationCondition *)self.condition).location.coordinate;
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
    
    if ( ((g5LocationCondition *)self.condition).radius != 0 ) {
        if (self.radiusPolygon) {
            [self.mapView removeAnnotation:self.radiusPolygon];
        }
        self.radiusPolygon = [self polygonCircleForCoordinate:((g5LocationCondition *)self.condition).location.coordinate
                                              withMeterRadius:((g5LocationCondition *)self.condition).radius];
        [self.mapView addAnnotation:self.radiusPolygon];
    }
}

- (void)refreshAddressLabel {
    if ( ((g5LocationCondition *)self.condition).location != nil ) {
        self.addressLabel.text = ((g5LocationCondition *)self.condition).address;
    }
}

#pragma mark - Progress HUD

-(void)displayProgressHUD {
    
}

- (void)hideProgressHUD {
    
}

#pragma mark - MGLMapViewDelegate

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

- (MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id <MGLAnnotation>)annotation
{
    // Try to reuse the existing ‘pisa’ annotation image, if it exists
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:annotation.title];
    
    if ( ! annotationImage) {
        UIImage *image;
        if ([annotation.title isEqualToString:MDRLocationAnnotationTitle]) {
            image = [UIImage imageNamed:@"location_on"];
        }
        else if ([annotation.title isEqualToString:MDRGrippyAnnotationTitle]) {
            image = [UIImage imageNamed:@"date_on"];
        }
        else {
            image = [UIImage imageNamed:@"date_off"];
        }
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:annotation.title];
    }
    
    return annotationImage;
}

@end
