//
//  SettingsDataSource.m

//
//  Created on 3/26/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "AppSettingsDataSource.h"
#import "ToggleTableViewCell.h"

//Geozone Manager Delegate
NSString *SAGeozoneManagerDelegateShowRegionAlerts = @"SAGeozoneManagerDelegateShowRegionAlerts";
NSString *SAGeozoneManagerDelegateShowZoneAddRemoveUpdateAlerts = @"SAGeozoneManagerDelegateShowZoneAddRemoveUpdateAlerts";

//Zone Event Manager Delegate
NSString *SAZoneEventManagerDelegateShowRegionAlerts = @"SAZoneEventManagerDelegateShowRegionAlerts";
NSString *SAZoneEventManagerDelegateShowZoneAddRemoveUpdateAlerts = @"SAZoneEventManagerDelegateShowZoneAddRemoveUpdateAlerts";

//Message Notifications Listener
NSString *SAMessageNotificationsListenerShowMessageAlerts = @"SAMessageNotificationsListenerShowMessageAlerts ShowRegionAlerts";

//Zone Notifications Listener
NSString *SAZoneNotificationsListenerShowRegionAlerts = @"SAZoneNotificationsListenerShowRegionAlerts ShowRegionAlerts";
NSString *SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts = @"SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts";

#pragma mark - AppSettingsSection

@interface AppSettingsSection()

@property (nonatomic) NSString *sectionName;
@property (nonatomic) NSArray /* Setting */ *settings;

+ (instancetype)sectionWithName:(NSString*)name andSettings:(NSArray*)settings;

@end

@implementation AppSettingsSection

+ (instancetype)sectionWithName:(NSString*)name andSettings:(NSArray*)settings
{
    AppSettingsSection *section = [AppSettingsSection new];
    section.sectionName = [name copy];
    section.settings = [settings copy];
    return section;
}

@end

#pragma mark - AppSettingsDataSource

@interface AppSettingsDataSource()

@property (nonatomic) NSDictionary *settingsDictionary;

@end

@implementation AppSettingsDataSource

#pragma mark - Initialization

- (instancetype)init
{
    if (self = [super init]) {
        _settingsDictionary = [self defaultSettingsDictionary];
    }
    return self;
}

#pragma mark - Shared instance

+ (instancetype)sharedInstance
{
    static AppSettingsDataSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [AppSettingsDataSource new];
    });
    return sharedInstance;
}

#pragma mark - <SettingDataSource>

- (void)setValue:(NSObject*)value toSettingWithKey:(NSString*)key
{
    if (key) {
        if (value) {
            [[NSUserDefaults standardUserDefaults] setObject:value.copy forKey:key];
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (NSObject*)getValueForSettingWithKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    NSObject *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!value) {
        NSDictionary *settingsDictionary = self.settingsDictionary;
        Setting *setting = settingsDictionary[key];
        value = setting.defaultValue;
    }
    return value;
}

#pragma mark - Public methods

- (NSArray*)settingsSections
{
    NSDictionary *settingsDictionary = [self settingsDictionary];
    return @[
              [AppSettingsSection sectionWithName:@"Message Notifications Listener" andSettings:
               @[
                settingsDictionary[SAMessageNotificationsListenerShowMessageAlerts]
                ]],
              [AppSettingsSection sectionWithName:@"Zone Notifications Listener" andSettings:
               @[
                 settingsDictionary[SAZoneNotificationsListenerShowRegionAlerts],
                 settingsDictionary[SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts]
                 ]],
              [AppSettingsSection sectionWithName:@"Geozone Manager Delegate" andSettings:
               @[
                 settingsDictionary[SAGeozoneManagerDelegateShowRegionAlerts],
                 settingsDictionary[SAGeozoneManagerDelegateShowZoneAddRemoveUpdateAlerts]
                ]],
              [AppSettingsSection sectionWithName:@"Zone Event Manager Delegate" andSettings:
               @[
                 settingsDictionary[SAZoneEventManagerDelegateShowRegionAlerts],
                 settingsDictionary[SAZoneEventManagerDelegateShowZoneAddRemoveUpdateAlerts]
                 ]]
            ];
}

#pragma mark - Private methods

- (NSDictionary*)defaultSettingsDictionary
{
    return @{
             SAMessageNotificationsListenerShowMessageAlerts:
                 [Setting settingWithDisplayName:@"Show Message Alerts" key:SAMessageNotificationsListenerShowMessageAlerts  andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(YES)],
             
             SAZoneNotificationsListenerShowRegionAlerts:
                 [Setting settingWithDisplayName:@"Show Region Alerts" key:SAZoneNotificationsListenerShowRegionAlerts  andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(NO)],
             SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts:
                 [Setting settingWithDisplayName:@"Show Zone CRUD Alerts" key:SAZoneNotificationsListenerShowZoneAddRemoveUpdateAlerts andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(NO)],
             SAGeozoneManagerDelegateShowRegionAlerts:
                 [Setting settingWithDisplayName:@"Show Region Alerts" key:SAGeozoneManagerDelegateShowRegionAlerts andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(NO)],
             SAGeozoneManagerDelegateShowZoneAddRemoveUpdateAlerts:
                 [Setting settingWithDisplayName:@"Show Zone CRUD Alerts" key:SAGeozoneManagerDelegateShowZoneAddRemoveUpdateAlerts andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(NO)],
             SAZoneEventManagerDelegateShowRegionAlerts:
                 [Setting settingWithDisplayName:@"Show Region Alerts" key:SAZoneEventManagerDelegateShowRegionAlerts  andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(NO)],
             SAZoneEventManagerDelegateShowZoneAddRemoveUpdateAlerts:
                 [Setting settingWithDisplayName:@"Show Zone CRUD Alerts" key:SAZoneEventManagerDelegateShowZoneAddRemoveUpdateAlerts andCellClassName:NSStringFromClass([ToggleTableViewCell class]) defaultValue:@(NO)],
             };
}

@end

