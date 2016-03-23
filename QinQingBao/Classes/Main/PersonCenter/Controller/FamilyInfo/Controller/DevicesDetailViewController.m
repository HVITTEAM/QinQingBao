

//
//  DevicesDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DevicesDetailViewController.h"
#import "DeviceInfoModel.h"

@interface DevicesDetailViewController ()

@end

@implementation DevicesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNaviBar];
    
    [self initTableView];
    
    [self setupGroups];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -- 初始化子视图方法 --
/**
 *  初始化导航栏
 */
-(void)initNaviBar
{
    self.navigationItem.title = self.selectedDevice.device_name;
}

/**
 *  初始化表视图
 */
-(void)initTableView
{
    self.tableView.backgroundColor = HMGlobalBg;
}

# pragma  mark -- setter、getter 方法 --
-(void)setSelectedDevice:(DeviceInfoModel *)selectedDevice
{
    _selectedDevice = selectedDevice;
}

# pragma  mark -- 设置数据源 --
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    //每次刷新数据源的时候需要将数据源清空
    [self.groups removeAllObjects];
    
    //重置数据源
    [self setupGroup0];
    
    //刷新表格
    [self.tableView reloadData];
}

/**
 *  设置第0个 section 数据
 */
- (void)setupGroup0
{
    HMCommonGroup *group = [HMCommonGroup group];
    group.header = @"设备信息";
    
    HMCommonItem *deviceName = [HMCommonItem itemWithTitle:@"设备名称"];
    deviceName.subtitle = self.selectedDevice.device_name;
    
    HMCommonItem *deviceCode = [HMCommonItem itemWithTitle:@"设备识别码"];
    deviceCode.subtitle = self.selectedDevice.device_code;
    
    group.items = @[deviceName,deviceCode];
    [self.groups addObject:group];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
