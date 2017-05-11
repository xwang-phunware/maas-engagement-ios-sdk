//
//  ZoneDetailsViewController.m

//
//  Created on 4/13/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "ZoneDetailsViewController.h"
#import "MapAnnotation.h"
#import <PWEngagement/PWMEGeozone.h>

static NSString * kSAMonitoredInsideRegionCircle = @"SAMonitoredInsideRegionCircle";
static NSString * kSAMonitoredOutsideRegionCircle = @"SAMonitoredOutsideRegionCircle";
static NSString * kSANonMonitoredRegionCircle = @"SANonMonitoredRegionCircle";


@interface ZoneDetailsViewController ()

@property (nonatomic,weak) IBOutlet UITableView *tagsTableView;

@property (nonatomic,weak) IBOutlet UILabel *zoneDescription;
@property (nonatomic,weak) IBOutlet UILabel *code;
@property (nonatomic,weak) IBOutlet UILabel *inside;

@property (nonatomic,weak) IBOutlet MKMapView *mapview;

@end

@implementation ZoneDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.zone.name;
    self.mapview.delegate  = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:PWMEEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:PWMEExitGeoZoneNotificationKey object:nil];
    
    [self updateUI];
}

- (void)updateUI
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.zoneDescription.text = self.zone.zoneDescription;
        self.code.text  = self.zone.code;
        
        self.tagsTableView.layer.borderColor = [UIColor grayColor].CGColor;
        self.tagsTableView.layer.borderWidth = 1;
        
		
        if ([self.zone monitored])
        {
            self.inside.text = self.zone.inside?@"Inside":@"Outside";
            if (self.zone.inside) {
                self.inside.textColor = [UIColor colorWithRed:51/255.0 green:153/255.0 blue:51/255.0 alpha:1];
            }else{
                self.inside.textColor = [UIColor blueColor];
            }
        }else if (![self.zone monitored])
        {
            self.inside.text = @"Not Monitored";
            self.inside.textColor = [UIColor redColor];
        }else{
            self.inside.text = @"";
        }
        
        if ([self.zone isKindOfClass:[PWMEGeozone class]]) {
            self.mapview.hidden = NO;
            [self updateGeozoneMap];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEExitGeoZoneNotificationKey object:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.zone tags] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TagNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSArray *tagsArray = [[self.zone tags] allObjects];
    cell.textLabel.text = [tagsArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Tags";
    return @"unexpected section";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}

#pragma mark - Map view 

- (void)updateGeozoneMap
{
    PWMEGeozone *geozone = (PWMEGeozone*)self.zone;
    
    NSMutableArray *overlaysToAdd = @[].mutableCopy;
    NSMutableArray *annotationsToAdd = @[].mutableCopy;
    
    CLCircularRegion * region = geozone.region;
    
    if ([self.zone monitored])
    {
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
        if (geozone.inside) {
            circle.title = kSAMonitoredInsideRegionCircle;
        }else{
            circle.title = kSAMonitoredOutsideRegionCircle;
        }
        [overlaysToAdd addObject:circle];
        
        MapAnnotation *pointAnnotation = [MapAnnotation new];
        pointAnnotation.coordinate = region.center;
        pointAnnotation.title = geozone.name;
        pointAnnotation.zone = geozone;
        [annotationsToAdd addObject:pointAnnotation];
    }else{
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
        circle.title = kSANonMonitoredRegionCircle;
        [overlaysToAdd addObject:circle];
        
    }
    
    [self.mapview removeAnnotations:[self.mapview.annotations copy]];
    [self.mapview removeOverlays:[self.mapview.overlays copy]];
    
    [self.mapview addOverlays:overlaysToAdd];
    [self.mapview addAnnotations:annotationsToAdd];
    
    [self.mapview setRegion:MKCoordinateRegionMake(region.center, MKCoordinateSpanMake(0.005, 0.05))];
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
    }
    renderer.lineWidth = 2;
    
    return renderer;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == self.mapview.userLocation) {
        return nil;
    }
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"123"];
    if ([annotation isKindOfClass:[MapAnnotation class]]) {
        
        MapAnnotation *mapAnnotation = (MapAnnotation *)annotation;
        
        MKPinAnnotationView * pinAnnotationView = (MKPinAnnotationView*)annotationView;
        if (pinAnnotationView == nil) {
            pinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"123"];
        }
        
        pinAnnotationView.pinTintColor = [UIColor redColor];
        if ([mapAnnotation.zone isKindOfClass:[PWMEGeozone class]])
        {
            PWMEGeozone *geozone = (PWMEGeozone *) mapAnnotation.zone;
            if (geozone.inside) {
                pinAnnotationView.pinTintColor = [UIColor greenColor];
            }
        }
        return pinAnnotationView;
    }
    
    
    return annotationView;
}


@end
