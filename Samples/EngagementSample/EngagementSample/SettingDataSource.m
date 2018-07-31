//
//  SettingDataSource.m

//
//  Created on 4/13/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "SettingDataSource.h"

@implementation Setting

+ (instancetype)settingWithDisplayName:(NSString*)name key:(NSString*)key{
    return [self settingWithDisplayName:name key:key andCellClassName:nil defaultValue:nil];
}

+ (instancetype)settingWithDisplayName:(NSString*)name key:(NSString*)key andCellClassName:(NSString*)cellClassName defaultValue:(NSObject*)defaultValue
{
    Setting *setting = [[self class] new];
    setting.displayName = name;
    setting.cellClass = cellClassName;
    setting.key = key;
    setting.defaultValue = defaultValue;
    return setting;
}

@end
