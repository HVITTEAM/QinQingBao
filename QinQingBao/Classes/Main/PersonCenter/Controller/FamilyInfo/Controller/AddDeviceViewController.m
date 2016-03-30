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
#import "BasicInfoViewController.h"

@interface AddDeviceViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSDictionary *deviceDict;
    
    NSString *selectedDevicename;
}

@property (nonatomic,retain) HMCommonItem *item0;
@property (nonatomic,retain) HMCommonTextfieldItem *itemimei;
@property (nonatomic,retain) HMCommonItem *item1;
@property (nonatomic,retain) HMCommonTextfieldItem *item2;
@property (nonatomic,retain) HMCommonButtonItem *itemBtn;
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableSkin];
    
    [self setupGroups];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)initTableSkin
{
    self.title = @"添加设备";
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan.png"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
}

# pragma  mark 设置数据源
/**
 *  初始化模型数据
 */
- (void)setupGroups
{
    [self setupGroup0];
    [self setupGroup];
    [self setupGroup1];
    [self setupFooter];
}

- (void)setupGroup0
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    self.itemimei = [HMCommonTextfieldItem itemWithTitle:@"设备IMEI码" icon:nil];
    self.itemimei.placeholder = @"IMEI码或设备序列号";
    
    group.items = @[self.itemimei];
}

- (void)setupGroup
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    if (!self.item0)
        self.item0 = [HMCommonItem itemWithTitle:@"设备名称" icon:nil];
    if (!self.item1)
        self.item1 = [HMCommonItem itemWithTitle:@"设备型号" icon:nil];
    
    group.items = @[self.item0,self.item1];
}

- (void)setupGroup1
{
    HMCommonGroup *group = [HMCommonGroup group];
    [self.groups addObject:group];
    
    if (!self.item2)
        self.item2 = [HMCommonTextfieldItem itemWithTitle:@"SIM卡号" icon:nil];
    self.item2.placeholder = @"请输入正确的SIM卡号";
    group.items = @[self.item2];
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
    [headView initWithShowIndex:0];
    if (self.isFromStart)
        self.tableView.tableHeaderView = headView;
    
    UIView *footview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenH, 110)];
    
    // 1.创建按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 50)];
    
    // 2.设置属性
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    if (self.isFromStart)
        [okBtn setTitle:@"下一步" forState:UIControlStateNormal];
    else
        [okBtn setTitle:@"确认" forState:UIControlStateNormal];
    [okBtn setTitleColor:HMColor(255, 10, 10) forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background"] forState:UIControlStateNormal];
    [okBtn setBackgroundImage:[UIImage resizedImage:@"common_card_background_highlighted"] forState:UIControlStateHighlighted];
    [okBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:okBtn];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake((MTScreenW - 230)/2, 55, 230, 30)];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"infoimg.png"]];
    img.frame = CGRectMake(lab.x - 20, 58, 20, 20);
    lab.userInteractionEnabled = NO;
    lab.font = [UIFont systemFontOfSize:12];
    lab.text = @"可扫描设备条形码/二维码获取设备识别码";
    lab.textColor = HMColor(234, 100, 65);
    lab.textAlignment = NSTextAlignmentCenter;
    [footview addSubview:lab];
    [footview addSubview:img];
    self.tableView.tableFooterView = footview;
}

-(void)next:(UIButton *)sender
{
    [self.view endEditing:YES];
    if (self.itemimei.rightText.text.length == 0)
        return [NoticeHelper AlertShow:@"请输入设备识别码" view:self.view];
    
    //如果设备名称为空，说明需要取设备名称
    if (self.item0.subtitle.length == 0)
    {
        [self getDeviceInfor:self.itemimei.rightText.text];
    }
    else if (self.selectedFamily)//用户信息已经存在，属于后来新增设备
    {
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [CommonRemoteHelper RemoteWithUrl:URL_bamg_user_devide_rel parameters: @{@"device_code" : self.itemimei.rightText.text,
                                                                                 @"ud_id": self.selectedFamily.ud_id,
                                                                                 @"device_num":self.item2.rightText.text}
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         else
                                         {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }
                                         [HUD removeFromSuperview];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"发生错误！%@",error);
                                         [HUD removeFromSuperview];
                                         [self.view endEditing:YES];
                                     }];
    }
    else
    {
        BasicInfoViewController *vc = [[BasicInfoViewController alloc] init];
        vc.devicecode = self.itemimei.rightText.text;
        vc.isFromStart = self.isFromStart;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/**根据imei码获取设备信息*/
-(void)getDeviceInfor:(NSString *)imei
{
    [self.view endEditing:YES];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_get_device_code parameters: @{ @"condition" : imei}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     [HUD removeFromSuperview];
                                     id codeNum = [dict objectForKey:@"code"];
                                     NSDictionary *data = [dict objectForKey:@"datas"];
                                     
                                     id ud_name;
                                     
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                         return;
                                     }
                                     
                                     if ([[data allKeys] containsObject:@"ud_name"])
                                     {
                                         ud_name = [data objectForKey:@"ud_name"];
                                     }
                                     
                                     if(ud_name && ![ud_name isKindOfClass:[NSNull class]])
                                     {
                                         [NoticeHelper AlertShow:@"该设备已经被绑定" view:nil];
                                     }
                                     else
                                     {
                                         self.item0.subtitle = [data objectForKey:@"device_name"];
                                         self.item1.subtitle = [data objectForKey:@"device_detial"];
                                         [self.tableView reloadData];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [HUD removeFromSuperview];
                                 }];
}

//扫描条形码
-(void)scan
{
    ScanCodesViewController *scanCodeVC = [[ScanCodesViewController alloc] init];
    scanCodeVC.getcodeClick = ^(NSString *code){
        self.itemimei.rightText.text = code;
        [self getDeviceInfor:code];
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}


@end
