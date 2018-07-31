//
//  MapViewLegendCell.h

//
//  Created on 5/8/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWCircleView.h"
@import MapKit;

@interface MapViewLegendCell : UITableViewCell

@property IBOutlet PWCircleView *legendImage;
@property IBOutlet MKPinAnnotationView *pinAnnotation;
@property IBOutlet UILabel *topLegendLabel;
@property IBOutlet UILabel *bottomLegendLabel;

@end
