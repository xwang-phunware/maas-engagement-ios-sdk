//
//  AttributeTableViewCell.h

//
//  Created on 4/8/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AttributeTableViewCell : UITableViewCell

@property (nonatomic) IBOutlet UILabel *name;
@property (nonatomic) IBOutlet UITextField *value;
@property (nonatomic) IBOutlet UISegmentedControl *segment;

@end
