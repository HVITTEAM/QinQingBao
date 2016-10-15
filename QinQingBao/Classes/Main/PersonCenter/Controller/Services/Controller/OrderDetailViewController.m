//
//  OrderDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/3/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderModel.h"
#import "OrderServiceDetailCell.h"
#import "SettlementCell.h"
#import "ServiceInfoCell.h"
#import "BillCell.h"
#import "EvaluationItemCell.h"
#import "OrderDetailModel.h"
#import "TimeLineCell.h"
#import "WorkPicModel.h"
#import "OrderPayViewController.h"
#import "EvaDetailCell.h"
#import "SWYPhotoBrowserViewController.h"
#import "ServiceHeadCell.h"

#import "PaymentViewController.h"
#import "OrderRefundViewController.h"
#import "CancelOrderController.h"
#import "EvaluationViewController.h"
#import "OrderTableViewController.h"
#import "TimeLineModel.h"
#import "DeliverViewController.h"
#import "ReportViewController.h"
#import "ServiceInfoEmailCell.h"
#import "InterveneController.h"
#import "ReportListViewController.h"

#define kBottomViewHeight 50
#define kNavBarHeight 64

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BillCellDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)WorkPicModel *workPicInfo;

@property(strong,nonatomic)TimeLineModel *timeModel;

@property(strong,nonatomic)NSDateFormatter *formatterOut;

@property(strong,nonatomic)NSDateFormatter *formatterIn;

//界面底部的按钮
@property(strong,nonatomic)UIButton *oneBtn;

@property(strong,nonatomic)UIButton *twoBtn;

@property(strong,nonatomic)UIButton *threeBtn;

@property(strong,nonatomic)UIButton *fourBtn;

@end

@implementation OrderDetailViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    [self initTableView];
    
    [self loadOrderTimeline];
}

#pragma mark - setUI方法
/**
 *  创建UITableView
 */
-(void)initTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    NSInteger tableViewHeight = MTScreenH - kNavBarHeight;
    
    if ([self initBottomView])
        tableViewHeight = MTScreenH - kBottomViewHeight - kNavBarHeight;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, MTScreenW, tableViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

/**
 *  创建底部工具视图
 */
-(BOOL)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,MTScreenH - kBottomViewHeight, MTScreenW, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5f)];
    line.backgroundColor = HMColor(225, 225, 225);
    [bottomView addSubview:line];
    
    UIButton * (^btnBlock)(void) = ^UIButton *{
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn addTarget:self action:@selector(tapBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = HMColor(200, 200, 200).CGColor;
        btn.layer.borderWidth = 1.0f;
        btn.layer.cornerRadius = 8.0f;
        [bottomView addSubview:btn];
        return btn;
    };
    
    self.oneBtn = btnBlock();
    self.oneBtn.frame = CGRectMake(MTScreenW - 80, 7, 65, 35);
    
    self.twoBtn = btnBlock();
    self.twoBtn.frame = CGRectMake(MTScreenW - 155, 7, 65, 35);
    
    self.threeBtn = btnBlock();
    self.threeBtn.frame = CGRectMake(MTScreenW - 230, 7, 65, 35);
    
    self.fourBtn = btnBlock();
    self.fourBtn.frame = CGRectMake(MTScreenW - 305, 7, 65, 35);
    
    //默认按钮都隐藏
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    
    //获取状态描述和按钮标题
    NSDictionary *dict = [self.orderInfor getOrderStatusAndButtonTitle];

    NSArray *btnTitles = dict[kButtonTitles];
    
    for (NSString *title in btnTitles) {
        [self showButtonWithTitle:title];
    }

    return btnTitles.count > 0;
}

#pragma mark - setter、getter方法
-(NSDateFormatter *)formatterOut
{
    if (!_formatterOut) {
        _formatterOut = [[NSDateFormatter alloc] init];
        [_formatterOut setDateFormat:@"yyyy年MM月dd日 EEEE aa"];
    }
    return _formatterOut;
}

-(NSDateFormatter *)formatterIn
{
    if (!_formatterIn) {
        _formatterIn = [[NSDateFormatter alloc] init];
        [_formatterIn setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _formatterIn;
}

#pragma mark - 协议方法
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ||section == 1) {
        return 1;
    }else if (section == 4){   //评论
        if (!self.orderInfor.wgrade || !self.orderInfor.dis_con) {
            return 0;
        }
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        ServiceHeadCell *serviceHeadCell = [ServiceHeadCell createCellWithTableView:tableView];
        [serviceHeadCell setDataWithOrderModel:self.orderInfor];
        cell = serviceHeadCell;
        
    }else if (indexPath.section == 1){
        static NSString * sellerCellId = @"sellerCell";
        UITableViewCell *sellerCell = [tableView dequeueReusableCellWithIdentifier:sellerCellId];
        if (!sellerCell) {
            sellerCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:sellerCellId];
            sellerCell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *accessory = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            accessory.image = [UIImage imageNamed:@"phone"];
            sellerCell.accessoryView = accessory;
        }
        sellerCell.textLabel.text = @"商家电话";
        
        NSString *phoneStr;
        if (self.orderInfor.orgphone && self.orderInfor.orgphone.length > 0) {
            phoneStr = self.orderInfor.orgphone;
        }else if (self.orderInfor.orgtelnum && self.orderInfor.orgtelnum.length > 0){
            phoneStr = self.orderInfor.orgtelnum;
        }else{
            phoneStr = ShopTel1;
        }
        
        sellerCell.detailTextLabel.text = phoneStr;
        return sellerCell;

    }else if (indexPath.section == 2 && indexPath.row == 1){
        
        if ([self.orderInfor.tid isEqualToString:@"43"]) {
            //超声理疗是没有email的
            ServiceInfoCell *serviceInfoCell = [ServiceInfoCell createServiceInfoCellWithTableView:tableView];
            serviceInfoCell.formatterIn = self.formatterIn;
            serviceInfoCell.formatterOut = self.formatterOut;
            [serviceInfoCell setDataWithOrderModel:self.orderInfor];
            cell = serviceInfoCell;
        }else{
            //服务市场是有email的
            ServiceInfoEmailCell *serviceInfoCell = [ServiceInfoEmailCell createCellWithTableView:tableView];
            serviceInfoCell.formatterIn = self.formatterIn;
            serviceInfoCell.formatterOut = self.formatterOut;
            [serviceInfoCell setDataWithOrderModel:self.orderInfor];
            cell = serviceInfoCell;
        }
        
    }else if (indexPath.section == 3 && indexPath.row == 1){
        TimeLineCell *timeLineCell = [tableView dequeueReusableCellWithIdentifier:@"MTTimeLineCell"];
        if (timeLineCell == nil)
            timeLineCell =  [TimeLineCell timeLineCell];
        timeLineCell.item = self.timeModel;
        return timeLineCell;
        
    }else if (indexPath.section == 4 && indexPath.row == 1){
        EvaDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"evaDetailCell"];
        
        if (cell == nil)
            cell = [EvaDetailCell evaDetailCell];
        
        [cell setItem:self.orderInfor];
        return cell;
    }
    else{
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCellId"];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCellId"];
        }
        NSString *titleStr;
        switch (indexPath.section) {
            case 2:
                titleStr = @"服务信息";
                break;
            case 3:
                titleStr = @"服务跟踪";
                break;
            case 4:
                titleStr = @"客户评价";
                break;
            default:
                titleStr = @"";
                break;
        }
        titleCell.textLabel.text = titleStr;
        cell = titleCell;
    }
    return cell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 85;
    }else if (indexPath.section == 1){
        return 55;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        if ([self.orderInfor.tid isEqualToString:@"43"]) {
            return 200;
        }
        return 230;
    }else if (indexPath.section == 3 && indexPath.row == 1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else if (indexPath.section == 4 && indexPath.row == 1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) {
        return;
    }

    NSString *phoneStr;
    if (self.orderInfor.orgphone && self.orderInfor.orgphone.length > 0) {
        phoneStr = self.orderInfor.orgphone;
    }else if (self.orderInfor.orgtelnum && self.orderInfor.orgtelnum.length > 0){
        phoneStr = self.orderInfor.orgtelnum;
    }else{
        phoneStr = ShopTel1;
    }
    
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneStr]];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark BillCellDelegate
-(void)BillCell:(BillCell *)cell clickedImageViewInIndex:(NSInteger)index
{
    NSLog(@"%@",@(index));
    
    NSMutableArray *imageUrlArray = [[NSMutableArray alloc] init];
    for (NSString *urlStr in self.workPicInfo.pic_info) {
        NSString *url = [NSString stringWithFormat:@"%@/shop/%@%@",URL_Local,self.workPicInfo.url,urlStr];
        NSURL *imageURL = [[NSURL alloc] initWithString:url];
        [imageUrlArray addObject:imageURL];
    }
    
    SWYPhotoBrowserViewController *browser = [[SWYPhotoBrowserViewController alloc] initPhotoBrowserWithImageURls:imageUrlArray currentIndex:index placeholderImageNmae:@"placeholderImage"];
    [self presentViewController:browser animated:YES completion:nil];
}


#pragma mark - 事件方法
/**
 *  支付按钮点击调用
 */
-(void)tapBottomBtn:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    
    NSInteger counts = self.navigationController.viewControllers.count;
    UIViewController *backToVC = self.navigationController.viewControllers[counts - 2];
    
    if ([sender.titleLabel.text isEqualToString:@"取消"])
    {
        CancelOrderController *cancelView  = [[CancelOrderController alloc]init];
        cancelView.orderItem = self.orderInfor;
        cancelView.doneHandlerClick = ^(void){
            [(OrderTableViewController *)backToVC refleshData];
            [weakSelf.navigationController popToViewController:backToVC animated:YES];
        };
        [self.navigationController pushViewController:cancelView animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"去支付"])
    {
        PaymentViewController *paymentVC = [[PaymentViewController alloc] init];
        OrderModel *model = self.orderInfor;
        paymentVC.imageUrlStr = [NSString stringWithFormat:@"%@%@",URL_Img,model.item_url];
        paymentVC.content = model.icontent;
        paymentVC.wprice = model.wprice;
        paymentVC.wid = model.wid;
        paymentVC.wcode = model.wcode;
        paymentVC.store_id = model.store_id;
        paymentVC.productName = model.icontent;
        paymentVC.viewControllerOfback = backToVC;
        paymentVC.doneHandlerClick = ^{
            [(OrderTableViewController *)backToVC refleshData];
        };

        [self.navigationController pushViewController:paymentVC animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"联系商家"] || [sender.titleLabel.text isEqualToString:@"投诉"])
    {
        NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",ShopTel1]];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if ([sender.titleLabel.text isEqualToString:@"申请退款"])
    {
        OrderRefundViewController *refundVC = [[OrderRefundViewController alloc] init];
        OrderModel *model = self.orderInfor;
        refundVC.orderModel = model;
        refundVC.doneHandlerClick = ^{
            [(OrderTableViewController *)backToVC refleshData];
            [weakSelf.navigationController popToViewController:backToVC animated:YES];
        };
        [self.navigationController pushViewController:refundVC animated:YES];
    }
    else if ([sender.titleLabel.text isEqualToString:@"评价"])
    {
        EvaluationViewController *evaluationVC = [[EvaluationViewController alloc] init];
        OrderModel *model = self.orderInfor;
        evaluationVC.orderModel = model;
        evaluationVC.doneHandlerClick = ^{
            [(OrderTableViewController *)backToVC refleshData];
            [weakSelf.navigationController popToViewController:backToVC animated:YES];
        };
        [self.navigationController pushViewController:evaluationVC animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"查看物流"]){
        DeliverViewController *deliverVC = [[DeliverViewController alloc] init];
        OrderModel *model = self.orderInfor;
        deliverVC.wid = model.wid;
        [self.navigationController pushViewController:deliverVC animated:YES];
        
    }else if ([sender.titleLabel.text isEqualToString:@"干预方案"]){
        OrderModel *model = self.orderInfor;
        InterveneController *view = [[InterveneController alloc] init];
        view.wid = model.wid;
        [self.navigationController pushViewController:view animated:YES];
    }else if ([sender.titleLabel.text isEqualToString:@"检测报告"]){
        ReportListViewController *reportListVC = [[ReportListViewController alloc] init];
        OrderModel *model = self.orderInfor;
        reportListVC.wid = model.wid;
        [self.navigationController pushViewController:reportListVC animated:YES];
    }

}

#pragma mark - 网络相关方法

/**
 *  获取订单的时间轴
 */
-(void)loadOrderTimeline
{
    NSDictionary *dict =  @{@"key" : [SharedAppUtil defaultCommonUtil].userVO.key,
                            @"client" : @"ios",
                            @"wid":self.orderInfor.wid,
                            @"member_id": [SharedAppUtil defaultCommonUtil].userVO.member_id
                            };
    [CommonRemoteHelper RemoteWithUrl:URL_Workinfo_status_list parameters:dict type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        NSInteger codeNUm = [dict[@"code"] integerValue];
        if (codeNUm == 0)
        {
            self.timeModel = [TimeLineModel objectWithKeyValues:dict[@"datas"]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else
        {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"服务器访问失败");
    }];
    
}

#pragma mark - 工具方法
/**
 *  显示一个操作按钮,从右侧开始显示
 *
 *  @param title 新显示按钮的标题
 *
 *  @return 表示有按钮要显示
 */
-(BOOL)showButtonWithTitle:(NSString *)title
{
    if (self.oneBtn.hidden) {
        [self.oneBtn setTitle:title forState:UIControlStateNormal];
        self.oneBtn.hidden = NO;
        return YES;
    }
    
    if (self.twoBtn.hidden) {
        [self.twoBtn setTitle:title forState:UIControlStateNormal];
        self.twoBtn.hidden = NO;
        return YES;
    }
    
    if (self.threeBtn.hidden) {
        [self.threeBtn setTitle:title forState:UIControlStateNormal];
        self.threeBtn.hidden = NO;
        return YES;
    }
    
    if (self.fourBtn.hidden) {
        [self.fourBtn setTitle:title forState:UIControlStateNormal];
        self.fourBtn.hidden = NO;
        return YES;
    }
    
    return YES;
}

@end
