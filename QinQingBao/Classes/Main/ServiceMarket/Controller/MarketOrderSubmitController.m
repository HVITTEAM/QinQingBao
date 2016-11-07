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
#import "CustomInfoCell.h"
#import "ExtendFooterView.h"
#import "MarketCustomInfo.h"

@interface MarketOrderSubmitController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property(strong,nonatomic)MarketCustomInfo *customInfo;

@property(assign,nonatomic)BOOL isExtend;

@property(strong,nonatomic)UIView *bottomView;

@end

@implementation MarketOrderSubmitController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    [self getUserInfor];
    
    self.isExtend = NO;
    if (!_customInfo) {
        _customInfo = [[MarketCustomInfo alloc] init];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setBottomViewPosition];
}

#pragma mark - 界面相关
-(void)setupUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    [self.view addSubview:self.tableView];
}

/**
 *  创建提交按钮view
 */
-(UIView *)createBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 60)];
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
    return bottomView;
}

/**
 *  设置提交按钮view
 */
-(void)setBottomViewPosition
{
    [self.bottomView removeFromSuperview];
    self.tableView.tableFooterView = nil;
    self.bottomView = [self createBottomView];
    CGFloat h = 0;
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 2; j++) {
            NSIndexPath *idx = [NSIndexPath indexPathForRow:j inSection:i];
            h += [self tableView:self.tableView heightForRowAtIndexPath:idx];
        }
        h += [self tableView:self.tableView heightForFooterInSection:i];
        h += [self tableView:self.tableView heightForHeaderInSection:i];
    }
    
    if (h + 64 + 60 > MTScreenH) {
        self.tableView.frame = CGRectMake(0, 0, MTScreenW, MTScreenH);
        self.tableView.tableFooterView = self.bottomView;
    }else{
        self.tableView.frame = CGRectMake(0, 0, MTScreenW, MTScreenH - 60);
        self.bottomView.frame = CGRectMake(0, MTScreenH - 60, MTScreenW, 60);
        [self.view addSubview:self.bottomView];
    }
}

#pragma mark - 协议方法
#pragma  mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
            titleCell.textLabel.text = self.shopItem.orgname;
            titleCell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            titleCell.textLabel.text = @"下单须知";
            titleCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell = titleCell;
    }else if (indexPath.section == 0){
        //客户信息
        CustomInfoCell *infoCell = [CustomInfoCell createCellWithTableView:tableView];
        [infoCell setdataWithCustomInfo:self.customInfo];
        infoCell.isExtend = self.isExtend;
        [infoCell setupCellHeight];
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
    if (section == 1) {
        return 10;
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 45;
    }
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        __weak typeof (self) weakSelf = self;
      ExtendFooterView *v = [[ExtendFooterView alloc] initWithTitle:@"查看详情" extendTitle:@"收起详情" imageName:@"arrowdown" extend:self.isExtend section:section];
        v.extendFooterViewTapCallBack = ^(NSInteger section, BOOL extend){
            weakSelf.isExtend = extend;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self setBottomViewPosition];
        };
        return v;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.row) {
        return 50;
    }else if (1== indexPath.section){
        return 120;
    }
    return [self tableView:tableView cellForRowAtIndexPath:indexPath].height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    if (indexPath.section == 0 && indexPath.row == 0) {
        MarketCustominfoController *vc = [[MarketCustominfoController alloc] init];
        vc.customInfo = self.customInfo;
        vc.customInfoCallBack = ^(MarketCustomInfo * customInfo){
            weakSelf.customInfo = customInfo;
            [weakSelf.tableView reloadData];
            
            [self setBottomViewPosition];
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
    if(![SharedAppUtil checkLoginStates])
        return;
    if (self.customInfo.name.length <= 0)
        return [NoticeHelper AlertShow:@"请填写姓名" view:self.view];
    
    if (self.customInfo.tel.length <= 0)
        return [NoticeHelper AlertShow:@"请填写地址" view:self.view];
    
    if (self.customInfo.email.length <= 0)
        return [NoticeHelper AlertShow:@"请填写电子邮箱" view:self.view];
    
    if (self.customInfo.areainfo.length <= 0)
        return [NoticeHelper AlertShow:@"请填写有效地址" view:self.view];
    
    NSDate *cDate = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *time = [fmt stringFromDate:cDate];
    
    NSMutableDictionary *params = [@{
                                     @"iid" : self.dataItem.iid,
                                     @"member_id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                     @"wtime" : time,
                                     @"wname" : self.customInfo.name,
                                     @"wprice" : self.dataItem.promotion_price ? self.dataItem.promotion_price : self.dataItem.price_mem,
                                     @"dvcode" : self.customInfo.dvcode,
                                     @"wtelnum" : self.customInfo.tel,
                                     @"waddress" : self.customInfo.areainfo,
                                     @"client" : @"ios",
                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                     @"wlevel" : @"1",
                                     @"voucher_id" :  @"",
                                     @"pay_type" : @"1",
                                     @"item_sum" : @"1",
                                     @"wlat" : [SharedAppUtil defaultCommonUtil].lat ? [SharedAppUtil defaultCommonUtil].lat : @"",
                                     @"wlng" : [SharedAppUtil defaultCommonUtil].lon ? [SharedAppUtil defaultCommonUtil].lon : @"",
                                     @"w_status" : @"5",
                                     }mutableCopy];
    
    [params setValue:self.customInfo.email forKey: @"wemail"];
    [params setValue:@([MarketCustomInfo sexToNumber:self.customInfo.sex]) forKey: @"wc_sex"];
    [params setValue:self.customInfo.birthday forKey: @"wc_birthday"];
    [params setValue:self.customInfo.height forKey: @"wc_height"];
    [params setValue:self.customInfo.weight forKey: @"wc_weight"];
    [params setValue:@([MarketCustomInfo womanSpecialToNumber:self.customInfo.womanSpecial]) forKey: @"wc_monthday"];
    [params setValue:self.customInfo.caseHistory forKey: @"wc_sickhistory"];
    [params setValue:self.customInfo.medicine forKey: @"wc_medication"];
    
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

/**
 *  获取用户数据数据
 */
-(void)getUserInfor
{
    if ([SharedAppUtil defaultCommonUtil].userVO == nil)
    {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    [CommonRemoteHelper RemoteWithUrl:URL_GetUserInfor parameters: @{@"id" : [SharedAppUtil defaultCommonUtil].userVO.member_id,
                                                                     @"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                                                                     @"client" : @"ios"}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     id codeNum = [dict objectForKey:@"code"];
                                     if([codeNum isKindOfClass:[NSString class]])//如果返回的是NSString 说明有错误
                                     {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[dict objectForKey:@"errorMsg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                                         [alertView show];
                                     }
                                     else
                                     {
                                         NSDictionary *di = [dict objectForKey:@"datas"];
                                         
                                        UserInforModel* infoVO = [UserInforModel objectWithKeyValues:di];
                                         
                                         self.customInfo.name = infoVO.member_truename;
                                         self.customInfo.tel = infoVO.member_mobile;
                                         self.customInfo.email = infoVO.member_email;
                                         
                                         self.customInfo.sex = [MarketCustomInfo numberToSex:[infoVO.member_sex integerValue]];
                                         
                                         self.customInfo.birthday = infoVO.member_birthday;
                                         self.customInfo.totalname = infoVO.totalname;
                                         self.customInfo.areainfo = infoVO.member_areainfo;
                                         self.customInfo.dvcode = infoVO.member_areaid;
                                         
                                         [self.tableView reloadData];
                                         
                                         [self setBottomViewPosition];
                                     }
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [self.view endEditing:YES];
                                 }];
}




@end
