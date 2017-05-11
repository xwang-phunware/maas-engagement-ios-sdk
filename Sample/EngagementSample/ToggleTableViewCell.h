//
//  ToggleTableViewCell.h

//
//  Created on 3/26/15.
//  Copyright (c) 2016 Phunware, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingDataSource.h"
#import "SettingTableViewCellProtocol.h"

@interface ToggleTableViewCell : UITableViewCell <SettingTableViewCellProtocol>

- (void)configureWithDataSource:(id<SettingDataSource>)datasource andSetting:(Setting*)setting;


@end
