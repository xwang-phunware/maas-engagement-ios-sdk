//
//  DetailsViewController.m
//
//  Created on 2/21/13.
//  Copyright (c) 2013 Jason Schmitt. All rights reserved.
//

#import "AppInfoViewController.h"
#import <PWEngagement/PWMEGeozone.h>

#import "PWEngagement+Helper.h"

static NSString *const MaxMonitorRegionRadius = @"50,000";


@interface AppInfoViewController ()

@property (nonatomic, strong) CLLocationManager *clLocationManager;

@end

@implementation AppInfoViewController

#pragma mark - UIViewController

-(void)awakeFromNib{
	[super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEAddGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEModifyGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEDeleteGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEExitGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEReceiveMessageNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEDeleteGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMEMonitoredGeoZoneChangesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:PWMELocationServiceReadyNotificationKey object:nil];
    
    self.clLocationManager = [CLLocationManager new];
    [self.clLocationManager requestAlwaysAuthorization];
    
    UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
    [notificationCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionBadge | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateUI:nil];
}

#pragma mark - Internal

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUI:nil];
    });
}

- (void)updateUI:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.appId.text = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MaaSAppId"];
        self.server.text = @"PROD";
        self.sdkVersion.text = [PWEngagement version];
        self.deviceID.text = [PWEngagement deviceId];
        self.deviceOS.text = [[UIDevice currentDevice] systemVersion];
        self.searchRadius.text = MaxMonitorRegionRadius;
        self.numberOfMessages.text = [NSString stringWithFormat:@"%lu", (long)[[PWEngagement messages] count]];
        
        NSArray *locations = [PWEngagement geozones];
        NSArray *monitoredZones = [PWEngagement monitoredZones];
        NSArray *insideZones = [PWEngagement insideZones];
        
        self.numberOfZones.text = [NSString stringWithFormat:@"%lu", (unsigned long)[locations count]];
        self.numberOfMonitoredZones.text = [NSString stringWithFormat:@"%lu", (unsigned long)[monitoredZones count]];
        self.numberOfInsideZones.text = [NSString stringWithFormat:@"%lu", (long)[insideZones count]];
    });
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEAddGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEModifyGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEDeleteGeoZonesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEEnterGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEExitGeoZoneNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEReceiveMessageNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEDeleteMessageNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMEMonitoredGeoZoneChangesNotificationKey object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PWMELocationServiceReadyNotificationKey object:nil];
}

@end
