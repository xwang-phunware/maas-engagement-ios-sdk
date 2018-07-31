//
//  SettingTableViewCellProtocol.h

//
//  Created on 3/26/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "SettingDataSource.h"

@protocol SettingTableViewCellProtocol

- (void)configureWithDataSource:(id<SettingDataSource>)datasource andSetting:(Setting*)setting;

@end
