//
//  SettingsTableViewController.m

//
//  Created on 3/26/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "AppSettingsDataSource.h"
#import "ToggleTableViewCell.h"
#import "SettingTableViewCellProtocol.h"

@interface SettingsTableViewController ()

@property (strong,nonatomic) UIBarButtonItem *btnSound;

@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    for (AppSettingsSection *settingsSection in [AppSettingsDataSource sharedInstance].settingsSections) {
        for (Setting *setting in settingsSection.settings) {
        [self.tableView registerNib:[UINib nibWithNibName:setting.cellClass bundle:nil] forCellReuseIdentifier:setting.cellClass];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    AppSettingsSection *settingsSection = [AppSettingsDataSource sharedInstance].settingsSections[section];
    return settingsSection.sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [AppSettingsDataSource sharedInstance].settingsSections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppSettingsSection *settingsSection = [AppSettingsDataSource sharedInstance].settingsSections[section];
    return settingsSection.settings.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppSettingsSection *settingsSection = [AppSettingsDataSource sharedInstance].settingsSections[indexPath.section];
    Setting *setting = settingsSection.settings[indexPath.row];
    
    Class cellClass = NSClassFromString(setting.cellClass);
    
    UITableViewCell <SettingTableViewCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    [cell configureWithDataSource:[AppSettingsDataSource sharedInstance] andSetting:setting];
    
    return cell;
}




@end
