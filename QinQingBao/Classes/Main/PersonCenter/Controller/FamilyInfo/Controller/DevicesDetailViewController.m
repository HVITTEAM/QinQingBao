

//
//  DevicesDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DevicesDetailViewController.h"
#import "DeviceInfoModel.h"

#import "EditInfoTableViewController.h"

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
    
    //设备SIM卡
    HMCommonArrowItem *simCode = [HMCommonArrowItem itemWithTitle:@"设备SIM卡" icon:@""];
    simCode.subtitle = self.selectedDevice.device_num;
    __weak __typeof(self)weakSelf = self;
    simCode.operation = ^{
        EditInfoTableViewController *textFieldVC = [[EditInfoTableViewController alloc]init];
        textFieldVC.titleStr = @"设备SIM卡";
        textFieldVC.contentStr = self.selectedDevice.device_num;
        textFieldVC.placeholderStr = @"请输入正确的设备SIM卡号";
        textFieldVC.finishUpdateOperation = ^(NSString *title,NSString *content,NSString *placeholder){
            [weakSelf uploadFamilyInforWithFamilyModel:content];
        };
        [weakSelf.navigationController pushViewController:textFieldVC animated:YES];
    };
    
    group.items = @[deviceName,deviceCode,simCode];
    [self.groups addObject:group];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

/**更新信息*/
-(void)uploadFamilyInforWithFamilyModel:(NSString *)device_num
{
    [CommonRemoteHelper RemoteWithUrl:URL_edit_device_num parameters: @{@"device_num" :device_num,
                                                                        @"deviceid": self.selectedDevice.deviceid,
                                                                        @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                                                                        @"client":@"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"修改成功");
                                         self.selectedDevice.device_num = device_num;
                                         [self setupGroups];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}


@end
