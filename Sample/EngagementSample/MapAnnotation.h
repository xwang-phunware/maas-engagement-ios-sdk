//
//  MapAnnotation.h
//  LocalpointSample
//
//  Created on 9/24/14.
//  Copyright (c) 2016 Phunware, Inc. All rights reserved.
//

#import <PWEngagement/PWEngagement.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : MKPointAnnotation

@property (nonatomic, strong) id<PWMEZone> zone;

@property (nonatomic) BOOL isLastPosition;

@end
