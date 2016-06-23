//
//  MarketOrderSubmitController.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketOrderSubmitController.h"
#import "MarketOrderCell.h"
#import "MarketPromptCell.h"
#import "SWYSubtitleCell.h"
#import "PaymentViewController.h"
#import "MarketCustominfoController.h"
#import "OrderItem.h"

@interface MarketOrderSubmitController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property (strong,nonatomic)NSString *customName;

@property (strong,nonatomic)NSString *customTel;

@property (strong,nonatomic)NSString *customAddress;

@property (strong,nonatomic)NSString *customEmail;

@end

@implementation MarketOrderSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

-(void)setupUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - 60) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 60, MTScreenW, 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 1)];
    line.backgroundColor = HMColor(230, 230, 230);
    [bottomView addSubview:line];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, MTScreenW - 40, 40)];
    [btn setTitle:@"提交订单" forState:UIControlStateNormal];
    btn.backgroundColor = HMColor(255, 126, 0);
    btn.layer.cornerRadius = 8.0f;
    [btn addTarget:self action:@selector(commitHandle:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
    [self.view addSubview:bottomView];
}

#pragma mark - 协议方法
#pragma  mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.customName) {
            return 1;
        }
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        //每个section的标题
        static NSString *titleCellId = @"titleCell";
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:titleCellId];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:titleCellId];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.section == 0) {
            titleCell.textLabel.text = @"客户信息";
            titleCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.section == 1){
            titleCell.textLabel.text = @"寸欣健康科技馆";
            titleCell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            titleCell.textLabel.text = @"下单须知";
            titleCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell = titleCell;
    }else if (indexPath.section == 0){
        //客户信息
        SWYSubtitleCell *infoCell = [SWYSubtitleCell createSWYSubtitleCellWithTableView:tableView];
        infoCell.detailTextLabel.textColor = [UIColor darkGrayColor];
        infoCell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        infoCell.textLabel.text = [NSString stringWithFormat:@"%@  %@",self.customName,self.customTel];
        infoCell.detailTextLabel.text = self.customAddress;
        cell = infoCell;
    }else if (indexPath.section == 1){
        //店铺信息
        MarketOrderCell *marketOrderCell = [MarketOrderCell createCellWithTableView:tableView];
        [marketOrderCell setItem:self.dataItem];
        cell = marketOrderCell;
    }else{
        //下单须知
        MarketPromptCell *pCell = [MarketPromptCell createCellWithTableView:tableView];
        pCell.contentStr = self.dataItem.remark;
        cell = pCell;
    }
    cell.layoutMargins = UIEdgeInsetsZero;
    return cell;
}

#pragma  mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 50;
    }else if (0 == indexPath.section){
        return 70;
    }else if (1== indexPath.section){
        return 120;
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        MarketCustominfoController *vc = [MarketCustominfoController initWith:self.customName tel:self.customTel address:self.customAddress email:self.customEmail];
        vc.inforClick = ^(NSString *name,NSString *tel,NSString *address,NSString *email){
            self.customName = name;
            self.customTel = tel;
            self.customAddress = address;
            self.customEmail = email;
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 事件方法
/**
 *  提交预约
 */
-(void)commitHandle:(UIButton *)sender
{
    if (self.customName == nil)
        return [NoticeHelper AlertShow:@"请选择联系人信息" view:self.view];
    NSDate *cDate = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *time = [fmt stringFromDate:cDate];
    
    NSMutableDictionary *params = [@{
                                     @"iid" : self.dataItem.iid,
                                     @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                     @"wtime" : time,
                                     @"wname" : self.customName,
                                     @"wprice" : self.dataItem.price_mem,
                                     @"dvcode" : self.shopItem.dvcode,
                                     @"wtelnum" : self.customTel,
                                     @"waddress" : self.shopItem.totalname,
                                     @"client" : @"ios",
                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"wlevel" : @"1",
                                     @"wremark" : @"用户留言",
                                     @"voucher_id" :  @"",
                                     @"pay_type" : @"1",
                                     @"item_sum" : @"1",
                                     @"wlat" : [SharedAppUtil defaultCommonUtil].lat ? [SharedAppUtil defaultCommonUtil].lat : @"",
                                     @"wlng" : [SharedAppUtil defaultCommonUtil].lon ? [SharedAppUtil defaultCommonUtil].lon :@"",
                                     @"w_status" : @"5",
                                     }mutableCopy];
    
    [params setValue:self.customEmail forKey: @"email"];
    
    
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [CommonRemoteHelper RemoteWithUrl:URL_Create_order parameters: params
                                     type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                         
                                         id codeNum = [dict objectForKey:@"code"];
                                         if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                         {
                                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                             [alertView show];
                                         }
                                         OrderItem *item = [OrderItem objectWithKeyValues:[dict objectForKey:@"datas"]];
                                         if (item.wcode.length != 0)
                                         {
                                             
                                             PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
                                             
                                             paymentVC.imageUrlStr = [NSString stringWithFormat:@"%@%@",URL_Img,self.dataItem.item_url];
                                             paymentVC.content = self.dataItem.iname;
                                             paymentVC.wprice = item.wprice;
                                             paymentVC.wid = item.wid;
                                             paymentVC.wcode = item.wcode;
                                             paymentVC.store_id = item.store_id;
                                             paymentVC.productName = self.dataItem.iname;
                                             
                                             NSUInteger count = self.navigationController.viewControllers.count;
                                             paymentVC.viewControllerOfback = self.navigationController.viewControllers[count -2];
                                             [self.navigationController pushViewController:paymentVC animated:YES];
                                             
                                         }
                                         [HUD removeFromSuperview];
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [NoticeHelper AlertShow:@"下单失败!" view:self.view];
                                         [HUD removeFromSuperview];
                                     }];
}

    


@end
