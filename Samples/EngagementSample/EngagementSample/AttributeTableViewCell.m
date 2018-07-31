//
//  AttributeTableViewCell.m

//
//  Created on 4/8/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "AttributeTableViewCell.h"

@implementation AttributeTableViewCell

- (IBAction)doneEditing:(UITextField*)sender {
    [sender resignFirstResponder];
}

@end
