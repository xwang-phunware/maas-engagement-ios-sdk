//
//  SettingsDataSource.h

//
//  Created on 3/26/15.
//  Copyright (c) 2016 Phunware, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SettingDataSource.h"

extern NSString *SAGeozoneManagerDelegateShowRegionAlerts;
extern NSString *SAGeozoneManagerDelegateShowZoneAddRemoveUpdateAlerts;

extern NSString *SAZoneEventManagerDelegateShowRegionAlerts;
extern NSString *SAZoneEventManagerDelegateShowZoneAddRemoveUpdateAlerts;

extern NSString *SAMessageNotificationsListenerShowMessageAlerts;

extern NSString *SAZoneNotificationsListenerShowRegionAlerts;
extern NSString *SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts;


@interface AppSettingsSection : NSObject

@property (readonly,nonatomic) NSString *sectionName;
@property (readonly,nonatomic) NSArray /* Setting */ *settings;

@end


@interface AppSettingsDataSource : NSObject<SettingDataSource>

+ (instancetype)sharedInstance;

@property (readonly,nonatomic) NSArray /* AppSettingsSection */ *settingsSections;

@end
