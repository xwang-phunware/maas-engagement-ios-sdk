//
//  SettingDataSource.h

//
//  Created on 4/13/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingDataSource <NSObject>

- (void)setValue:(NSObject*)value toSettingWithKey:(NSString*)key;

- (NSObject*)getValueForSettingWithKey:(NSString *)key;

@end


@interface Setting : NSObject

@property (nonatomic) NSString *displayName;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *cellClass;
@property (nonatomic) NSObject *defaultValue;

+ (instancetype)settingWithDisplayName:(NSString*)name key:(NSString*)key;
+ (instancetype)settingWithDisplayName:(NSString*)name key:(NSString*)key andCellClassName:(NSString*)cellClassName defaultValue:(NSObject*)defaultValue;

@end
