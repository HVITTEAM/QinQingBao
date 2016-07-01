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
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5f)];
    line.backgroundColor = HMColor(225, 225, 225);
    [bottomView addSubview:line];
    
    BOOL isShow =[self getStatusByStatus:[self.orderInfor.status intValue] payStatus:[self.orderInfor.pay_staus intValue]];
    return isShow;
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
        return 200;
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
    }else if ([sender.titleLabel.text isEqualToString:@"查看物流"]){
        DeliverViewController *deliverVC = [[DeliverViewController alloc] init];
        OrderModel *model = self.orderInfor;
        deliverVC.wid = model.wid;
        [self.navigationController pushViewController:deliverVC animated:YES];
        
    }else if ([sender.titleLabel.text isEqualToString:@"查看医嘱"]){
        ReportViewController *reportVC = [[ReportViewController alloc] init];
        OrderModel *model = self.orderInfor;
        reportVC.wid = model.wid;
        [self.navigationController pushViewController:reportVC animated:YES];
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
    NSString *str = nil;
    BOOL isShowBottomView = NO;
    
    //默认按钮都隐藏
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    
    if (status >= 0 && status <= 9) {
        
        if (payStatus == 0){
            str = @"未付款";
           isShowBottomView = [self showButtonWithTitle:@"取消"];
           isShowBottomView = [self showButtonWithTitle:@"去支付"];
            
        }else if (payStatus == 1) {
            str = @"已付款";
            
            if (status == 8) {
                str = @"已分派";
            }
            
            //超声理疗只要付了钱并分派了技师就可以评价,服务市场需要配送报告或上传报告后才能评价
            if (status >= 8) {
                //tid 43是超声理疗 44是服务市场
                if ([self.orderInfor.tid isEqualToString:@"43"]) {
                    if([self.orderInfor.wgrade floatValue] <= 0 && self.orderInfor.dis_con==nil){
                        isShowBottomView =[self showButtonWithTitle:@"评价"];
                    }
                }
            }
            
            if (!self.orderInfor.voucher_id) {
                //不是优惠券支付时才能退款
               isShowBottomView = [self showButtonWithTitle:@"申请退款"];
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
           isShowBottomView = [self showButtonWithTitle:@"取消"];
            isShowBottomView = [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            if (status == 15) {
                str = @"服务开始";
            }
            
            //超声理疗只要付了钱分并派了技师就可以评价,服务市场需要配送报告或上传报告后才能评价
            //tid 43是超声理疗 44是服务市场
            if ([self.orderInfor.tid isEqualToString:@"43"]) {
                if([self.orderInfor.wgrade floatValue] <= 0 && self.orderInfor.dis_con==nil){
                   isShowBottomView = [self showButtonWithTitle:@"评价"];
                }
            }
            
            if (!self.orderInfor.voucher_id) {
                //不是优惠券支付时才能退款
               isShowBottomView = [self showButtonWithTitle:@"申请退款"];
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
        
    }else if (status >= 20 && status <= 29){
        if (payStatus == 0){
            str = @"未支付";
           isShowBottomView = [self showButtonWithTitle:@"取消"];
           isShowBottomView = [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            //只要器皿寄送出去了就不能退款
            //配送器皿相当于服务开始,配送报告或上传报告相当于服务结束（完成)
            
            if (status == 20) {
                //器皿配送
                str = @"配送器皿";
                isShowBottomView = [self showButtonWithTitle:@"查看物流"];
                
            }else if (status == 21){
                str = @"已上传报告";
                isShowBottomView = [self showButtonWithTitle:@"查看物流"];
                isShowBottomView = [self showButtonWithTitle:@"查看医嘱"];
                if([self.orderInfor.wgrade floatValue] <= 0 && self.orderInfor.dis_con==nil){
                   isShowBottomView = [self showButtonWithTitle:@"评价"];
                }
                
            }else if(status == 22){
                //派送开始
                
            }else if (status == 23 ){
                str = @"已配送报告";
                isShowBottomView = [self showButtonWithTitle:@"查看物流"];
                isShowBottomView = [self showButtonWithTitle:@"查看医嘱"];
                if([self.orderInfor.wgrade floatValue] <= 0 && self.orderInfor.dis_con==nil){
                    isShowBottomView = [self showButtonWithTitle:@"评价"];
                }
            }else if (status == 25){
                //派送结束
                
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    }else if (status >= 30 && status <= 39){
        if (payStatus == 0){
            str = @"未支付";
            isShowBottomView = [self showButtonWithTitle:@"取消"];
            isShowBottomView =[self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            if (status == 32) {
                //评价了就不能退款
                str = @"服务完成";
                if([self.orderInfor.wgrade floatValue] <= 0 && self.orderInfor.dis_con==nil){
                    isShowBottomView = [self showButtonWithTitle:@"评价"];
                    if (!self.orderInfor.voucher_id){
                       isShowBottomView = [self showButtonWithTitle:@"申请退款"];
                    }
                }
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    }else if (status >= 40 && status <= 49){
        
        if (payStatus == 0){
            str = @"未支付";
            isShowBottomView = [self showButtonWithTitle:@"取消"];
            isShowBottomView = [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            if ([self.orderInfor.wgrade floatValue] > 0 || self.orderInfor.dis_con!=nil){
                str = @"已评价";
                //tid 43是超声理疗 44是服务市场
                if ([self.orderInfor.tid isEqualToString:@"44"]) {
                    isShowBottomView = [self showButtonWithTitle:@"查看物流"];
                    isShowBottomView = [self showButtonWithTitle:@"查看医嘱"];
                }
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
    }else if (status >= 100 && status <= 109){
        str = @"投诉中";
    }else if (status >= 110 && status <= 129){
        str = @"退货中";
    }

    
    return isShowBottomView;
}

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
