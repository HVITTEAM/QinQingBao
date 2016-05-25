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

#define kBottomViewHeight 50
#define kNavBarHeight 64

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BillCellDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)WorkPicModel *workPicInfo;

@property(strong,nonatomic)TimeLineModel *timeModel;

@property(strong,nonatomic)NSDateFormatter *formatterOut;

@property(strong,nonatomic)NSDateFormatter *formatterIn;

@property(strong,nonatomic)UIButton *bottomLeftBtn;

@property(strong,nonatomic)UIButton *bottomrigthBtn;

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
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.backgroundColor = [UIColor whiteColor];
    
     NSInteger tableViewHeight = MTScreenH - 64;
    
    if ([self initBottomView]) {
        
        tableViewHeight = MTScreenH - 64 - kBottomViewHeight;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, tableViewHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

/**
 *  创建底部工具视图
 */
-(BOOL)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,MTScreenH - kNavBarHeight - kBottomViewHeight, MTScreenW, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    self.bottomLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 165, 7, 70, 35)];
    [self.bottomLeftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.bottomLeftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bottomLeftBtn addTarget:self action:@selector(tapBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomLeftBtn.layer.borderColor = HMColor(200, 200, 200).CGColor;
    self.bottomLeftBtn.layer.borderWidth = 1.0f;
    self.bottomLeftBtn.layer.cornerRadius = 8.0f;
    [bottomView addSubview:self.bottomLeftBtn];
    
    self.bottomrigthBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 80, 7, 70, 35)];
    [self.bottomrigthBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.bottomrigthBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bottomrigthBtn addTarget:self action:@selector(tapBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.bottomrigthBtn.layer.borderColor = HMColor(200, 200, 200).CGColor;
    self.bottomrigthBtn.layer.borderWidth = 1.0f;
    self.bottomrigthBtn.layer.cornerRadius = 8.0f;
    [bottomView addSubview:self.bottomrigthBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5f)];
    line.backgroundColor = HMColor(225, 225, 225);
    [bottomView addSubview:line];
    
    BOOL isHide =[self getStatusByStatus:[self.orderInfor.status intValue] payStatus:[self.orderInfor.pay_staus intValue]];
    return isHide;
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
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 3){   //评论
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
        
    }else if (indexPath.section == 1 && indexPath.row == 1){
        ServiceInfoCell *serviceInfoCell = [ServiceInfoCell createServiceInfoCellWithTableView:tableView];
        serviceInfoCell.formatterIn = self.formatterIn;
        serviceInfoCell.formatterOut = self.formatterOut;
        [serviceInfoCell setDataWithOrderModel:self.orderInfor];
        cell = serviceInfoCell;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        TimeLineCell *timeLineCell = [tableView dequeueReusableCellWithIdentifier:@"MTTimeLineCell"];
        if (timeLineCell == nil)
            timeLineCell =  [TimeLineCell timeLineCell];
        timeLineCell.item = self.timeModel;
        
        return timeLineCell;
        
    }else if (indexPath.section == 3 && indexPath.row == 1){
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
            case 1:
                titleStr = @"服务信息";
                break;
            case 2:
                titleStr = @"服务跟踪";
                break;
            case 3:
                titleStr = @"对理疗师评价";
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
    }else if (indexPath.section == 1 && indexPath.row == 1){
        return 240;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else if (indexPath.section == 3 && indexPath.row == 1){
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
        NSURL *url = [NSURL URLWithString:@"telprompt://4001512626"];
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
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
 *  根据工单状态设置要显示的操作按钮
 */
-(BOOL)getStatusByStatus:(int)status payStatus:(int)payStatus
{
    NSString *str;
    
    //默认按钮都隐藏
    [self setleftBtnTitle:nil leftBtnHide:YES rightBtnTitle:nil rightBtnHide:YES];
    
    if (status >= 0 && status <= 9) {
        
        if (payStatus == 0){
            str = @"未支付";
            [self setleftBtnTitle:@"去支付" leftBtnHide:NO rightBtnTitle:@"取消" rightBtnHide:NO];
            return YES;
        }else if (payStatus == 1) {
            str = @"已支付";
            if (status == 8) {
                str = @"已分派";
            }
            if (!self.orderInfor.voucher_id) {
                [self setleftBtnTitle:nil leftBtnHide:YES rightBtnTitle:@"申请退款" rightBtnHide:NO];
                return YES;
            }
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
        
    }else if (status >= 10 && status <= 19){
        
        if (payStatus == 0){
            str = @"未支付";
            [self setleftBtnTitle:@"去支付" leftBtnHide:NO rightBtnTitle:@"取消" rightBtnHide:NO];
            return YES;
        }else if (payStatus == 1) {
            str = @"已分派";
            if (status == 15) {
                str = @"服务开始";
            }
            
            if (!self.orderInfor.voucher_id) {
                [self setleftBtnTitle:nil leftBtnHide:YES rightBtnTitle:@"申请退款" rightBtnHide:NO];
                return YES;
            }
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
        
    }else if (status >= 20 && status <= 29){
        //无
    }else if (status >= 30 && status <= 49){
        if (payStatus == 0){
            str = @"未支付";
            [self setleftBtnTitle:@"去支付" leftBtnHide:NO rightBtnTitle:@"取消" rightBtnHide:NO];
            return YES;
        }else if (payStatus == 1) {
            str = @"服务完成";
            if (status == 32) {
                str = @"服务完成";
                [self setleftBtnTitle:@"申请退款" leftBtnHide:NO rightBtnTitle:@"评价" rightBtnHide:NO];
                return YES;
            }
            
            if (status == 42 || [self.orderInfor.wgrade floatValue] != 0 || self.orderInfor.dis_con!=nil) {
                str = @"已评价";
            }
            
            if (status == 45) {
                str = @"服务完成";
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
        
    }else if (status >= 50 && status <= 59){
        str = @"已取消";
    }else if (status >= 60 && status <= 69){
        str = @"已拒单";
    }else if (status >= 70 && status <= 79){
        //无
    }else if (status >= 80 && status <= 99){
        str = @"完成";
    }else if (status >= 100 && status <= 119){
        str = @"投诉中";
    }else if (status >= 110 && status <= 129){
        str = @"退货中";
    }
    
    return NO;
}

/**
 *  设置底部工具条按钮状态
 */
-(void)setleftBtnTitle:(NSString *)leftTitle
           leftBtnHide:(BOOL)isLeftHide
          rightBtnTitle:(NSString *)rightTitle
           rightBtnHide:(BOOL)isRightBtnHide
{
    self.bottomLeftBtn.hidden = isLeftHide;
    [self.bottomLeftBtn setTitle:leftTitle forState:UIControlStateNormal];
    
    self.bottomrigthBtn.hidden = isRightBtnHide;
    [self.bottomrigthBtn setTitle:rightTitle forState:UIControlStateNormal];
}

@end
