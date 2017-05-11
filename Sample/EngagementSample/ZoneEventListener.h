//
//  ZoneEventListener.h

//
//  Created on 4/20/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZoneEventListener : NSObject

/**
 Register for listening zone events
 */
- (void)startListening;

/**
 Unregister for listening zone events
 */
- (void)stopListening;

@end
