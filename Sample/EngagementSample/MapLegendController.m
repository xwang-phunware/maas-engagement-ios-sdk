//
//  MapLegendController.m

//
//  Created on 5/12/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

@import MapKit;
#import "MapLegendController.h"
#import "MapViewLegendCell.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString * const MapViewLegendCellIdentifier = @"MapViewLegendCellIdentifier";

@implementation MapLegendController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 10.0;
    [self.tableView registerNib:[UINib nibWithNibName:@"MapViewLegendCell" bundle:nil] forCellReuseIdentifier:MapViewLegendCellIdentifier];
}

#pragma mark 

- (void)configureCell:(MapViewLegendCell*)cell atIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            cell.legendImage.circleColor = [UIColor greenColor];
            cell.topLegendLabel.text = @"Location Marketting";
            cell.bottomLegendLabel.text = @"Monitored zone - Inside";
            cell.legendImage.hidden = NO;
            cell.pinAnnotation.hidden = NO;
            cell.pinAnnotation.pinTintColor = [UIColor greenColor];
            break;
        }
        case 1:
        {
            cell.legendImage.circleColor = [UIColor blueColor];
            cell.topLegendLabel.text = @"Location Marketting";
            cell.bottomLegendLabel.text = @"Monitored zone - Outside";
            cell.legendImage.hidden = NO;
            cell.pinAnnotation.hidden = NO;
			cell.pinAnnotation.pinTintColor = [UIColor redColor];
            break;
        }
        case 2:
        {
            cell.legendImage.circleColor = [UIColor redColor];
            cell.topLegendLabel.text = @"Location Marketting";
            cell.bottomLegendLabel.text = @"Non-monitored zone";
            cell.legendImage.hidden = NO;
            cell.pinAnnotation.hidden = YES;
            break;
        }
        case 3:
        {
            cell.topLegendLabel.text = @"Location Marketting";
            cell.bottomLegendLabel.text = @"Last position known by SDK";
            cell.legendImage.hidden = YES;
            cell.pinAnnotation.hidden = NO;
			cell.pinAnnotation.pinTintColor = [UIColor purpleColor];
            break;
        }
        case 4:
        {
            cell.legendImage.circleColor = [UIColor purpleColor];
            cell.topLegendLabel.text = @"iOS Location manager - Debugging";
            cell.bottomLegendLabel.text = @"Monitored zone";
            cell.legendImage.hidden = NO;
            cell.pinAnnotation.hidden = YES;
            break;
        }
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)dismissModalController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <UITableViewDataSource>

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapViewLegendCell *cell = [tableView dequeueReusableCellWithIdentifier:MapViewLegendCellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        return UITableViewAutomaticDimension;
    }
    
    static MapViewLegendCell *dummyCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dummyCell = [self.tableView dequeueReusableCellWithIdentifier:MapViewLegendCellIdentifier];
        if (!dummyCell) {
            dummyCell = [[MapViewLegendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MapViewLegendCellIdentifier];
        }
    });
    
    [self configureCell:dummyCell atIndexPath:indexPath];
    
    dummyCell.bounds = CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds),CGRectGetHeight(dummyCell.bounds));
    
    [dummyCell setNeedsLayout];
    [dummyCell layoutIfNeeded];
    
    CGFloat height = [dummyCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1.0;
}


@end
