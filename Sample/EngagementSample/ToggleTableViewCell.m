//
//  ToggleTableViewCell.m

//
//  Created on 3/26/15.
//  Copyright (c) 2016 Phunware Inc. All rights reserved.
//

#import "ToggleTableViewCell.h"

@interface ToggleTableViewCell()

@property (nonatomic,strong) IBOutlet UILabel *toggleLabel;
@property (nonatomic,strong) IBOutlet UISwitch *toggleSwitch;
@property (nonatomic,weak) IBOutlet id <SettingDataSource>datasource;
@property (nonatomic,strong) IBOutlet Setting *setting;


@end

@implementation ToggleTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
    [self.toggleSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)configureWithDataSource:(id<SettingDataSource>)datasource andSetting:(Setting*)setting {
    self.datasource = datasource;
    self.setting  = setting;
    self.toggleLabel.text = setting.displayName;
    NSNumber * value = (NSNumber*) [self.datasource getValueForSettingWithKey:setting.key];
    [self.toggleSwitch setOn:value?value.boolValue:NO animated:NO];
}

- (void)changeSwitch:(id)sender
{
    if([sender isOn]){
        [self.datasource setValue:@(YES) toSettingWithKey:self.setting.key];
    } else{
        [self.datasource setValue:@(NO) toSettingWithKey:self.setting.key];
    }
}

@end
