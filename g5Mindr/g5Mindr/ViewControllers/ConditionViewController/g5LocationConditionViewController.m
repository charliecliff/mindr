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

@import Mapbox;
@import MapKit;

@interface g5LocationConditionViewController () <MGLMapViewDelegate>

@property(nonatomic, strong) IBOutlet UILabel *addressLabel;

@property(nonatomic, strong) IBOutlet MGLMapView *mapView;
@property(nonatomic, strong) MGLPointAnnotation *locationAnnotation;

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
        
    UILongPressGestureRecognizer *gsRecog = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressMapView:)];
    [self.mapView addGestureRecognizer:gsRecog];
}

- (void)setUpNavigationBar {
    self.navigationItem.title = @"Location";
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeTop;
}

#pragma mark - Actions

- (void)didLongPressMapView:(UIGestureRecognizer *)gesureRecognizer {
    //  1. Set the location of the Condition
    CGPoint point = [gesureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    
    ((g5LocationCondition *)self.condition).location = [[CLLocation alloc] initWithLatitude:coord.latitude
                                                                                  longitude:coord.longitude];
    
    //  2. Fetch the Address String
    __weak g5LocationConditionViewController *weakSelf = self;
    [[g5LocationManager sharedManager] getAddressForLocation:((g5LocationCondition *)self.condition).location
                                                 withSuccess:^(NSString *addressLine) {
                                                     g5LocationConditionViewController *strongSelf = weakSelf;
                                                     ((g5LocationCondition *)strongSelf.condition).address = addressLine;
                                                     [strongSelf refresh];
                                                 }
                                                 withFailure:nil];
    
    //  3. Refresh the Map
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
        self.locationAnnotation.title = @"Leaning Tower of Pisa";
        [self.mapView addAnnotation:self.locationAnnotation];
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
    MGLAnnotationImage *annotationImage = [mapView dequeueReusableAnnotationImageWithIdentifier:@"pisa"];
    
    // If the ‘pisa’ annotation image hasn‘t been set yet, initialize it here
    if ( ! annotationImage)
    {
        // Leaning Tower of Pisa by Stefan Spieler from the Noun Project
        UIImage *image = [UIImage imageNamed:@"location_on"];
        
        // The anchor point of an annotation is currently always the center. To
        // shift the anchor point to the bottom of the annotation, the image
        // asset includes transparent bottom padding equal to the original image
        // height.
        //
        // To make this padding non-interactive, we create another image object
        // with a custom alignment rect that excludes the padding.
        image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, image.size.height/2, 0)];
        
        // Initialize the ‘pisa’ annotation image with the UIImage we just loaded
        annotationImage = [MGLAnnotationImage annotationImageWithImage:image reuseIdentifier:@"pisa"];
    }
    
    return annotationImage;
}

@end
