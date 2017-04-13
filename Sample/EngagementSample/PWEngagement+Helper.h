//
//
//  Created on 2/8/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PWEngagement/PWEngagement.h>

@interface PWEngagement(Helper)

+ (NSArray *)monitoredGeozones;

+ (NSArray *)insideGeozones;

+ (PWMEZoneMessage *)getMessage:(NSString *)messageId;

@end
