

//
//  DevicesDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "DevicesDetailViewController.h"
#import "EditContactViewController.h"
#import "AddContactViewController.h"
#import "FamilyModel.h"
#import "DeviceInfoModel.h"
#import "RelationModel.h"

@interface DevicesDetailViewController ()

@property (strong,nonatomic) NSMutableArray *emergencyContacts;            //紧急联系人数组

@property(assign,nonatomic)BOOL isWatch;       //设备是否是手表，是手表的话要设置添加紧急联系人按钮

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
    
    [self getEmergencyContactData];
    
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
    
    if (!self.isWatch) {
        return;
    }
    
    //设置底部按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 0, 50);
    [addBtn setTitle:@"+ 添加紧急联系人" forState:UIControlStateNormal];
    [addBtn setTitleColor:MTNavgationBackgroundColor forState:UIControlStateNormal];
    [addBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [addBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = addBtn;
}

# pragma  mark -- setter、getter 方法 --
-(void)setSelectedDevice:(DeviceInfoModel *)selectedDevice
{
    _selectedDevice = selectedDevice;
    
    //根据选择的设备名字判断是否为手表
    self.isWatch = NO;
    if ([selectedDevice.device_name isEqualToString:@"手表"]) {
        self.isWatch = YES;
    }
}

-(NSMutableArray *)emergencyContacts
{
    if (!_emergencyContacts) {
        _emergencyContacts = [[NSMutableArray alloc] init];
    }
    return _emergencyContacts;
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
    [self setupGroup1];
    
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

/**
 *  设置第0个 section 数据
 */
- (void)setupGroup1
{
    //没有紧急联系人就不设置section
    if (self.emergencyContacts.count == 0) {
        return;
    }
    
    HMCommonGroup *group = [HMCommonGroup group];
    group.header = @"紧急联系人";
    
    NSMutableArray *tempItemArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.emergencyContacts.count; i++) {
        RelationModel *model = self.emergencyContacts[i];
        HMCommonArrowItem *item = [HMCommonArrowItem itemWithTitle:[NSString stringWithFormat:@"%@   %@",model.rname,model.rtelnum]];
        item.subtitle = model.relation;
        [tempItemArray addObject:item];
        model.index = i;
        item.operation = ^{
            EditContactViewController *editVC = [[EditContactViewController alloc] init];
            editVC.item = model;
            editVC.editResultClick = ^(RelationModel *relationMd){
                [self.emergencyContacts replaceObjectAtIndex:relationMd.index withObject:relationMd];
                [self uploadContactInfo];
            };
            editVC.deleteResultClick = ^(RelationModel *relationMd){
                if (self.emergencyContacts.count <= 1) {
                    [[[UIAlertView alloc] initWithTitle:@"请至少保留一个紧急联系人" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                    return;
                }
                [self.emergencyContacts removeObjectAtIndex:relationMd.index];
                [self uploadContactInfo];
            };
            
            [self.navigationController pushViewController:editVC animated:YES];
        };
    }
    group.items = tempItemArray;
    [self.groups addObject:group];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma  mark -- 事件方法 --
/**
 *  添加紧急联系人
 */
-(void)addContact:(UIButton *)sender
{
    if (self.emergencyContacts.count ==3){
        return [NoticeHelper AlertShow:@"紧急联系人最多设置3个" view:nil];
    }
    
    AddContactViewController*vc = [[AddContactViewController alloc] init];
    vc.addResultClick = ^(RelationModel *item){
        [self.emergencyContacts addObject:item];
        [self uploadContactInfo];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  获取紧急联系人数据
 */
-(void)getEmergencyContactData
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dict = @{@"member_id" : self.selectedFamilyMember.member_id};
    
    [CommonRemoteHelper RemoteWithUrl:URL_Get_relationfo  parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        [HUD removeFromSuperview];
        if ([dict[@"code"] integerValue] == 0) {
            
            NSMutableArray *dataArray = [RelationModel objectArrayWithKeyValuesArray:dict[@"datas"]];
            self.emergencyContacts = dataArray;
            [self setupGroups];
            
        }else if ([dict[@"code"] integerValue] == 17001){
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
            return;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [HUD removeFromSuperview];
        [NoticeHelper AlertShow:@"请求未成功" view:self.view];
    }];
}

/**
 *  上传紧急联系人信息
 */
-(void)uploadContactInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.selectedFamilyMember.member_id forKey:@"member_id"];
    [dict setValue:[NSString stringWithFormat:@"%d",(int)[self.emergencyContacts count]] forKey:@"sos_count"];
    
    for (int i = 1; i < self.emergencyContacts.count+1 ; i++)
    {
        RelationModel *obj = self.emergencyContacts[i-1];
        [dict setValue:obj.rname forKey:[NSString stringWithFormat:@"name_%d",i]];
        [dict setValue:obj.rtelnum forKey:[NSString stringWithFormat:@"mobile_%d",i]];
        [dict setValue:obj.relation forKey:[NSString stringWithFormat:@"relation_%d",i]];
    }
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_SOS_relationfo parameters: dict
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSLog(@"设置成功！");
                                         [self getEmergencyContactData];
                                         [self.navigationController popViewControllerAnimated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

@end
