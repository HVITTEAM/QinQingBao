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
#import "TimeLineModel.h"

#define kBottomViewHeight 50
#define kNavBarHeight 64

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BillCellDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)WorkPicModel *workPicInfo;

@property(strong,nonatomic)TimeLineModel *timeModel;

@property(strong,nonatomic)NSDateFormatter *formatterOut;

@property(strong,nonatomic)NSDateFormatter *formatterIn;

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
    
    //未支付，需要显示底部的支付视图
//    if ([self needsPay]) {
//        [self initBottomView];
//    }
}

#pragma mark - setUI方法
/**
 *  创建UITableView
 */
-(void)initTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSInteger tableViewHeight = MTScreenH - kBottomViewHeight;
    
//    if (![self needsPay]) {
//        tableViewHeight = MTScreenH - 64;
//    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

/**
 *  创建底部工具视图
 */
-(void)initBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,MTScreenH - kNavBarHeight - kBottomViewHeight, MTScreenW, kBottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIButton *payBtn = [[UIButton alloc] initWithFrame:CGRectMake(MTScreenW - 80, 7, 60, 35)];
    [payBtn setTitle:@"支付" forState: UIControlStateNormal];
    [payBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
    payBtn.layer.borderColor = HMColor(200, 200, 200).CGColor;
    payBtn.layer.borderWidth = 1.0f;
    payBtn.layer.cornerRadius = 8.0f;
    [bottomView addSubview:payBtn];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5f)];
    line.backgroundColor = HMColor(225, 225, 225);
    [bottomView addSubview:line];
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
        return 190;
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
-(void)pay:(UIButton *)sender
{
    PaymentViewController *payVC = [[PaymentViewController alloc] init];
    
    payVC.imageUrlStr = [NSString stringWithFormat:@"%@%@",URL_Img,self.orderInfor.item_url];
    payVC.content = self.orderInfor.icontent;
    payVC.wprice = self.orderInfor.wprice;
    payVC.wid = self.orderInfor.wid;
    payVC.wcode = self.orderInfor.wcode;
    payVC.productName = self.orderInfor.tname;
    payVC.viewControllerOfback = self.navigationController.viewControllers[1];
    
    [self.navigationController pushViewController:payVC animated:YES];
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
-(BOOL)needsPay
{
    NSInteger orderStatus = [self.orderInfor.status integerValue];
    
    //未支付，需要显示底部的支付视图
    if ( orderStatus >= 30 && orderStatus <= 39) {
        return YES;
    }
    
    if ( orderStatus >= 40 && orderStatus <= 49 && [self.orderInfor.pay_staus integerValue] == 0 ) {
        return YES;
    }
    
    return NO;
}

@end
