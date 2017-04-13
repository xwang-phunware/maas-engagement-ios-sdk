//
//  MapViewController.m
//  LocalpointSample
//
//  Created on 9/23/14.
//  Copyright (c) 2016. All rights reserved.
//
#import <PWEngagement/PWEngagement.h>
#import "PWEngagement+Helper.h"
#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "LPMapAnnotation.h"
#import "ZoneDetailsViewController.h"

static NSString * kSAMonitoredInsideRegionCircle = @"SAMonitoredInsideRegionCircle";
static NSString * kSAMonitoredOutsideRegionCircle = @"SAMonitoredOutsideRegionCircle";
static NSString * kSAMonitoredByCoreLocation = @"SAMonitoredByCoreLocation";
static NSString * kSAUpdateRegionCircle = @"SAUpdateRegionCircle";
static NSString * kSANonMonitoredRegionCircle = @"SANonMonitoredRegionCircle";


@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSSet *monitoredLocation;
@property (nonatomic, strong) NSSet *nonMonitoredLocation;
@end

@implementation MapViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Map";
    
    self.mapView.showsUserLocation = YES;
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMKCircles) name:PWMEEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMKCircles) name:PWMEExitGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMKCircles) name:PWMEMonitoredGeoZoneChangesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMKCircles) name:PWMEModifyGeoZonesNotificationKey object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshMKCircles];
    
    if (self.isMovingToParentViewController) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
            CLLocationCoordinate2D coordinate = kCLLocationCoordinate2DInvalid;
			
            if (CLLocationCoordinate2DIsValid(coordinate)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView setRegion:MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.25, 0.25))];
                });
            }
        });
    }
}

#pragma mark - Actions

- (void)showAll
{
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

#pragma mark - Internal

- (void)refreshMonitoredRegions
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        
        @autoreleasepool {
            
            NSMutableArray *overlaysToAdd = @[].mutableCopy;
            
            self.monitoredLocation = [NSSet setWithArray:[PWEngagement monitoredGeozones]];
            
            NSArray *coreLocationMonitoredRegions = [PWEngagement monitoredGeozones];
            
            for (CLRegion * region in coreLocationMonitoredRegions) {
                if ([region isKindOfClass:[CLCircularRegion class]]) {
                    CLCircularRegion *circularRegion = (CLCircularRegion*)region;
                    MKCircle *circleCl = [MKCircle circleWithCenterCoordinate:circularRegion.center radius:circularRegion.radius*0.98-20];
                    circleCl.title = kSAMonitoredByCoreLocation;
                    [overlaysToAdd addObject:circleCl];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableArray *overlaysToRemove = @[].mutableCopy;
                
                for (id<MKOverlay> overlay in self.mapView.overlays) {
                    if([overlay isKindOfClass:[MKCircle class]]){
                        MKCircle *circle = overlay;
                        if([circle.title isEqualToString:kSAMonitoredByCoreLocation]){
                            [overlaysToRemove addObject:circle];
                        }
                    }
                }
                [self.mapView removeOverlays:overlaysToRemove];
                [self.mapView addOverlays:overlaysToAdd];
                
            });
        }
    });
    
}

- (void)refreshMKCircles
{
    dispatch_async(dispatch_get_main_queue(),^{
    
        @autoreleasepool {
            
            NSMutableArray *overlaysToAdd = @[].mutableCopy;
            NSMutableArray *annotationsToAdd = @[].mutableCopy;
            
            self.monitoredLocation = [[NSSet alloc] initWithArray:[PWEngagement monitoredGeozones]];
            
            NSMutableSet *nonMonitored  = [[NSMutableSet alloc] initWithArray:[PWEngagement geozones]];
            [nonMonitored minusSet:self.monitoredLocation];
            self.nonMonitoredLocation = nonMonitored;
            
            NSArray *coreLocationMonitoredRegions = [PWEngagement monitoredGeozones];
            
            // Displaying the regions monitored by Core Location
            for (CLRegion * region in coreLocationMonitoredRegions) {
                if ([region isKindOfClass:[CLCircularRegion class]]) {
                    CLCircularRegion *circularRegion = (CLCircularRegion*)region;
                    MKCircle *circleCl = [MKCircle circleWithCenterCoordinate:circularRegion.center radius:circularRegion.radius*0.98-20];
                    circleCl.title = kSAMonitoredByCoreLocation;
                    [overlaysToAdd addObject:circleCl];
                }
            }
            
            for (PWMEGeozone* geozone in self.monitoredLocation) {
                
                CLCircularRegion * region = geozone.region;
                
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
                if (geozone.inside) {
                    circle.title = kSAMonitoredInsideRegionCircle;
                }else{
                    circle.title = kSAMonitoredOutsideRegionCircle;
                }
                [overlaysToAdd addObject:circle];
                
                LPMapAnnotation *pointAnnotation = [LPMapAnnotation new];
                pointAnnotation.coordinate = region.center;
                pointAnnotation.title = geozone.name;
                pointAnnotation.zone = geozone;
                [annotationsToAdd addObject:pointAnnotation];
            }
            
            for (PWMEGeozone* geozone in self.nonMonitoredLocation) {
                
                CLCircularRegion * region = geozone.region;
                
                MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
                circle.title = kSANonMonitoredRegionCircle;
                [overlaysToAdd addObject:circle];
            }
			
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mapView removeAnnotations:[self.mapView.annotations copy]];
                [self.mapView removeOverlays:[self.mapView.overlays copy]];
                
                [self.mapView addOverlays:overlaysToAdd];
                [self.mapView addAnnotations:annotationsToAdd];
                
            });
        }
    });
    
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *renderer = [[MKCircleRenderer alloc] initWithCircle:(MKCircle *)overlay];
    if ([overlay.title isEqualToString:kSAMonitoredInsideRegionCircle]) {
        renderer.fillColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:0/255.0 alpha:0.3];
        renderer.strokeColor = [UIColor colorWithRed:0/255.0 green:102/255.0 blue:0/255.0 alpha:1];
    }else if ([overlay.title isEqualToString:kSAMonitoredOutsideRegionCircle]){
        renderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        renderer.strokeColor = [UIColor blueColor];
    }else if ([overlay.title isEqualToString:kSANonMonitoredRegionCircle]){
        renderer.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
        renderer.strokeColor = [UIColor redColor];
    }else if ([overlay.title isEqualToString:kSAUpdateRegionCircle]){
        renderer.fillColor = [[UIColor yellowColor] colorWithAlphaComponent:0.1];
        renderer.strokeColor = [UIColor yellowColor];
    }else if ([overlay.title isEqualToString:kSAMonitoredByCoreLocation]){
        renderer.fillColor = [UIColor clearColor];
        renderer.strokeColor = [UIColor magentaColor];
    }
    
    renderer.lineWidth = 2;
    
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"123"];
    if ([annotation isKindOfClass:[LPMapAnnotation class]]) {
        
        LPMapAnnotation *mapAnnotation = (LPMapAnnotation*)annotation;
        
        MKPinAnnotationView * pinAnnotationView = (MKPinAnnotationView*)annotationView;
        if (pinAnnotationView == nil) {
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"123"];
            UIButton *disclosureButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinAnnotationView.rightCalloutAccessoryView = disclosureButton;
            pinAnnotationView.canShowCallout = YES;
        }
        
        pinAnnotationView.pinTintColor = [UIColor redColor];
        if ([mapAnnotation.zone isKindOfClass:[PWMEGeozone class]])
        {
            PWMEGeozone *geozone = (PWMEGeozone*) mapAnnotation.zone;
            if (geozone.inside) {
				pinAnnotationView.pinTintColor = [UIColor greenColor];
            }
        }
        if (mapAnnotation.isLastPosition) {
			pinAnnotationView.pinTintColor = [UIColor purpleColor];
            pinAnnotationView.canShowCallout = NO;
        }
        return pinAnnotationView;
    }
    
    
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    id<MKAnnotation> annotation = view.annotation;
    
    if ([annotation isKindOfClass:[LPMapAnnotation class]]) {
        
        LPMapAnnotation *mapAnnotation = (LPMapAnnotation*)annotation;
        
        if (mapAnnotation.zone)
        {
            ZoneDetailsViewController *zoneDetails = [self.storyboard instantiateViewControllerWithIdentifier:@"ZoneDetailsViewController"];
            zoneDetails.zone = mapAnnotation.zone;
            [self.navigationController pushViewController:zoneDetails animated:YES];
        }
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEExitGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEMonitoredGeoZoneChangesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEModifyGeoZonesNotificationKey object:nil];
}

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
