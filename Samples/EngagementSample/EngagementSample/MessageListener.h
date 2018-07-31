//
//  MessageListener.h

//
//  Created on 4/20/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListener : NSObject

/**
 Register for listening message events
 */
- (void)startListening;

/**
 Unregister for listening message events
 */
- (void)stopListening;

@end
