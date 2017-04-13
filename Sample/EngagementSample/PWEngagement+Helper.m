//

//
//  Created on 2/8/16.
//  Copyright © 2016 Phunware Inc. All rights reserved.
//

#import "PWEngagement+Helper.h"

@implementation PWEngagement(Helper)

+ (NSArray *)monitoredGeozones {
    return [[PWEngagement geozones] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"monitored == YES"]];
}

+ (NSArray *)insideGeozones {
    return [[PWEngagement geozones] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"inside == YES"]];
}

+ (PWMEZoneMessage *)getMessage:(NSString *)messageId {
    for (PWMEZoneMessage *message in [PWEngagement messages]) {
        if ([messageId isEqualToString:message.identifier]) {
            return message;
        }
    }
    
    return nil;
}

@end
