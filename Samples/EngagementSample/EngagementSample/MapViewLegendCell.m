//
//  MapViewLegendCell.m

//
//  Created on 5/8/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//
#import "MapViewLegendCell.h"

@implementation MapViewLegendCell

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
    
    self.topLegendLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.topLegendLabel.frame);
    [self.topLegendLabel setNeedsUpdateConstraints];
    
    self.bottomLegendLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bottomLegendLabel.frame);
    [self.bottomLegendLabel setNeedsUpdateConstraints];
}

@end
