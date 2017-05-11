//
//  ZoneDetailsViewController.h

//
//  Created on 4/13/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

@import MapKit;
@import UIKit;
#import <PWEngagement/PWEngagement.h>


@interface ZoneDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate>

@property (nonatomic,retain) id<PWMEZone> zone;

@end
