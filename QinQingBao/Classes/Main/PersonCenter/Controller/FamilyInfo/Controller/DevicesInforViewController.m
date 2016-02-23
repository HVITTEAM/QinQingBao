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
#import "FamilyModel.h"

@interface DevicesInforViewController ()

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
    self.navigationItem.title = self.selectedFamilyMember.member_truename;
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
    for (DeviceInfoModel *model in self.devicesArray) {
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:model.device_name];
        item.subtitle = model.device_code;
        [tempItemArray addObject:item];
        item.operation = ^{
            DevicesDetailViewController *detailVC = [[DevicesDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            detailVC.selectedFamilyMember = weakSelf.selectedFamilyMember;
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

#pragma mark -- 事件方法 --
/**
 *  添加设备绑定
 */
-(void)addDevices:(UIButton *)sender
{
    AddDeviceViewController *view = [[AddDeviceViewController alloc] init];
    view.member_id = self.selectedFamilyMember.member_id;
    [self.navigationController pushViewController:view animated:YES];
}


@end
