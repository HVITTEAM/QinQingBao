//
//  DevicesInforViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DevicesInforViewController.h"
#import "DevicesDetailViewController.h"
#import "AddDeviceViewController.h"
#import "DeviceInfoModel.h"
#import "DeviceModel.h"

@interface DevicesInforViewController ()<UIAlertViewDelegate>
{
    NSInteger selectedDeleteIndex;
}

@end

@implementation DevicesInforViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNaviBar];
    
    [self initTableView];
    
    [self setupGroups];
}

#pragma mark -- 初始化子视图方法 --
/**
 *  初始化导航栏
 */
-(void)initNaviBar
{
    self.navigationItem.title = self.selectedFamilyMember.ud_name;
}

/**
 *  初始化表视图
 */
-(void)initTableView
{
    self.tableView.backgroundColor = HMGlobalBg;
    
    //设置底部按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 0, 50);
    [addBtn setTitle:@"+ 添加设备" forState:UIControlStateNormal];
    [addBtn setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addDevices:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = addBtn;
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
    __weak typeof(self) weakSelf = self;
    
    HMCommonGroup *group = [HMCommonGroup group];
    NSMutableArray *tempItemArray = [[NSMutableArray alloc] init];
    for (DeviceInfoModel *model in self.devicesArray)
    {
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:model.device_name];
        item.subtitle = model.device_code;
        [tempItemArray addObject:item];
        item.operation = ^{
            DevicesDetailViewController *detailVC = [[DevicesDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            detailVC.selectedDevice = model;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        };
    }
    
    group.items = tempItemArray;
    [self.groups addObject:group];
}

#pragma mark -- 协议方法 --
#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.selectedFamilyMember.member_id isEqualToString:[SharedAppUtil defaultCommonUtil].userVO.member_id])
        return UITableViewCellEditingStyleDelete;
    else
        return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        selectedDeleteIndex = indexPath.row;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        DeviceInfoModel *model = self.devicesArray[selectedDeleteIndex];
        [self deleteDevice:model.deviceid];
    }
}

/**解绑设备*/
-(void)deleteDevice:(NSString *)imei
{
    [CommonRemoteHelper RemoteWithUrl:URL_del_base_user_devide parameters: @{@"ud_id" : self.selectedFamilyMember.ud_id,
                                                                             @"device_id": imei,
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
                                         [SharedAppUtil defaultCommonUtil].needRefleshMonitor = YES;
                                         [self.devicesArray removeObjectAtIndex:selectedDeleteIndex];
                                         self.selectedFamilyMember.device = self.devicesArray;
                                         [self setupGroups];
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"解绑成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}


#pragma mark -- 事件方法 --
/**
 *  添加设备绑定
 */
-(void)addDevices:(UIButton *)sender
{
    AddDeviceViewController *view = [[AddDeviceViewController alloc] init];
    view.selectedFamily = self.selectedFamilyMember;
    [self.navigationController pushViewController:view animated:YES];
}


@end
