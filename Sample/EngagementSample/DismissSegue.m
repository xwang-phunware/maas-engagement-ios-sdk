//
//  DismissSeque.m

//
//  Created on 4/29/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
    [self.sourceViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
