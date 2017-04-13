//
//  ZoneListViewController.m

//
//  Created on 4/13/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "ZoneListViewController.h"
#import "PWEngagement+Helper.h"
#import "MapViewController.h"
#import "ZoneListViewCell.h"
#import "ZoneDetailsViewController.h"

static NSString * const ZoneCell = @"ZoneCell";

@interface ZoneListViewController()

@property (nonatomic) NSArray *zones;
@property (nonatomic) NSArray *displayedZones;
@property (nonatomic) NSInteger selectedFilteringSegment;
@property (nonatomic) NSArray *notificationNames;

@end

@implementation ZoneListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notificationNames = @[PWMEAddGeoZonesNotificationKey,
                                   PWMEModifyGeoZonesNotificationKey,
                                   PWMEDeleteGeoZonesNotificationKey,
                                   PWMEEnterGeoZoneNotificationKey,
                                   PWMEExitGeoZoneNotificationKey,
                                   PWMEMonitoredGeoZoneChangesNotificationKey
                                   ];
    for (NSString *notificationName in self.notificationNames) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshZoneManagerDisplayInformation) name:notificationName object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshZoneManagerDisplayInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    for (NSString *notificationName in self.notificationNames) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LocationDetails"]) {
        id<PWMEZone> zone = self.displayedZones[[self.tableView indexPathForSelectedRow].row];
        ZoneDetailsViewController *details = (ZoneDetailsViewController*)segue.destinationViewController;
        details.zone = zone;
    }
}


#pragma mark - Private methods

- (void)refreshZoneManagerDisplayInformation {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.zones = [PWEngagement geozones];
        
        [self updateDisplayedZones];
    });
}

- (void)updateDisplayedZones {
    switch (self.selectedFilteringSegment) {
        case 0:
            self.displayedZones = self.zones;
            break;
        case 1:
        {
            NSMutableArray *insideZoneArray = @[].mutableCopy;
            for (id<PWMEZone> zone in self.zones) {
                if (zone.inside) {
                    [insideZoneArray addObject:zone];
                }
            }
            self.displayedZones = insideZoneArray;
            break;
        }
        case 2:
        {
            NSMutableArray *monitoredZoneArray = @[].mutableCopy;
            for (id<PWMEZone> zone in self.zones) {
                if (zone.monitored) {
                    [monitoredZoneArray addObject:zone];
                }
            }
            self.displayedZones = monitoredZoneArray;
            break;
        }
        default:
            break;
    }
    
    [self.tableView reloadData];
}

- (void)segmentedValueChanged:(UISegmentedControl *)segment {
    self.selectedFilteringSegment = segment.selectedSegmentIndex;
    
    [self updateDisplayedZones];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if(!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"All",@"Inside",@"Monitored"]];
        [segmentedControl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents: UIControlEventValueChanged];
        segmentedControl.selectedSegmentIndex = self.selectedFilteringSegment;
        [headerView addSubview:segmentedControl];
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        [headerView addConstraints:@[
                                     [NSLayoutConstraint constraintWithItem:headerView
                                                                  attribute:NSLayoutAttributeCenterX
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:segmentedControl
                                                                  attribute:NSLayoutAttributeCenterX
                                                                 multiplier:1.0
                                                                   constant:0],
                                     [NSLayoutConstraint constraintWithItem:headerView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:segmentedControl
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0
                                                                   constant:0]]];
        [headerView updateConstraints];
    }
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.zones count] > 0)
    {
        return 45;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:ZoneCell forIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZoneListViewCell *detailsCel = (ZoneListViewCell*)cell;
    detailsCel.selectionStyle = UITableViewCellSelectionStyleNone;
    id<PWMEZone> zone = self.displayedZones[indexPath.row];
    detailsCel.zoneName.text = [zone name];
    
    if ([zone monitored]) {
        detailsCel.insideStatus.font = [UIFont systemFontOfSize:15];
        detailsCel.insideStatus.text = zone.inside?@"Inside":@"Outside";
        if (zone.inside) {
            detailsCel.insideStatus.textColor = [UIColor colorWithRed:51/255.0 green:153/255.0 blue:51/255.0 alpha:1];
        } else {
            detailsCel.insideStatus.textColor = [UIColor blueColor];
        }
    } else {
        detailsCel.insideStatus.font = [UIFont systemFontOfSize:11];
        detailsCel.insideStatus.text = @"Not Monitored";
        detailsCel.insideStatus.textColor = [UIColor redColor];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displayedZones.count;
}

@end
