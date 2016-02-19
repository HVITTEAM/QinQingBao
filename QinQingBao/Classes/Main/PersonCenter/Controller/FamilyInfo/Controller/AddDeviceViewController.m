//
//  AddDeviceViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "HMCommonTextfieldItem.h"
#import "HMCommonButtonItem.h"
#import "HeadProcessView.h"
#import "ScanCodesViewController.h"
#import "EmergencyContactViewController.h"

@interface AddDeviceViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSDictionary *deviceDict;
    
    NSString *selectedDevicename;
}
@property (nonatomic,retain) HMCommonArrowItem *item0;
@property (nonatomic,retain) HMCommonTextfieldItem *item1;
@property (nonatomic,retain) HMCommonButtonItem *itemBtn;
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self setupGroups];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CommonRemoteHelper RemoteWithUrl:URL_Get_device_type parameters: @{@"condition" : @"name"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         deviceDict = [dict objectForKey:@"datas"];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                 }];
}

-(void)initTableSkin
{
    self.title = @"添加设备";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup];
    [self setupFooter];
}

- (void)setupGroup
{
    __weak __typeof(self)weakSelf = self;
    
    // 1.创建组
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的所有行数据
    self.item0 = [HMCommonArrowItem itemWithTitle:@"设备名称" icon:nil];
    self.item0.subtitle = selectedDevicename.length == 0 ?  @"请选择" : selectedDevicename;
    self.item0.operation = ^{
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: @"请选择设备名称"
                                                                 delegate: weakSelf
                                                        cancelButtonTitle: @"取消"
                                                   destructiveButtonTitle: nil
                                                        otherButtonTitles: nil];
        
        for (NSString *key in deviceDict)
        {
            NSLog(@"key: %@ value: %@", key, deviceDict[key]);
            [actionSheet addButtonWithTitle: deviceDict[key]];
        }
        [actionSheet showInView:weakSelf.view];
    };
    
    self.item1 = [HMCommonTextfieldItem itemWithTitle:@"设备识别码" icon:nil];
    self.item1.placeholder = @"IMEI码或序列号";
    self.item1.operation = ^{
        NSLog(@"----点击了n---");
    };
    
    group.items = @[self.item0,self.item1];
}

#pragma  mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString * str = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![str isEqualToString:@"取消"])
    {
        selectedDevicename = str;
        [self.groups removeAllObjects];
        [self setupGroup];
        [self.tableView reloadData];
    }
}

#pragma  mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)setupFooter
{
    HeadProcessView *headView = [[HeadProcessView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    headView.backgroundColor = HMGlobalBg;
    [headView initWithShowIndex:1];
    self.tableView.tableHeaderView = headView;
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [okBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:okBtn];
    
    self.tableView.tableFooterView = footview;
}

-(void)next:(UIButton *)sender
{
//    EmergencyContactViewController *VC = [[EmergencyContactViewController alloc] init];
//    [self.navigationController pushViewController:VC animated:YES];
//    return;
    [self.view endEditing:YES];
    if (selectedDevicename.length == 0)
    {
        return [NoticeHelper AlertShow:@"请选择设备名称" view:self.view];
    }
    else if (self.item1.rightText.text.length == 0)
    {
        return [NoticeHelper AlertShow:@"请输入设备识别码" view:self.view];
    }
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Add_device parameters: @{@"device_name" : @"手表",
                                                                   @"device_type":@"2",
                                                                   @"device_code" : self.item1.rightText.text,
                                                                   @"detail":@"HVIT-HM111",
                                                                   @"member_id":self.member_id}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         EmergencyContactViewController *VC = [[EmergencyContactViewController alloc] init];
                                         VC.member_id = self.member_id;
                                         [self.navigationController pushViewController:VC animated:YES];
                                     }
                                     [HUD removeFromSuperview];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                     [self.view endEditing:YES];
                                 }];
}

-(void)scan
{
    ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
    scanCodeVC.getcodeClick = ^(NSString *code){
        self.item1.rightText.text = code;
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

-(void)back
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否确认退出绑定流程？退出后可以在个人中心-->我的亲友中完成后续操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确认退出",nil];
    [alertView show];

}


@end
