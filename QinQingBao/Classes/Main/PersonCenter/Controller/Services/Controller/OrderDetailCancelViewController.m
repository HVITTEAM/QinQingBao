//
//  OrderDetailCancelViewController.m
//  QinQingBao
//
//  Created by shi on 16/4/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "OrderDetailCancelViewController.h"
#import "OrderModel.h"
#import "OrderServiceDetailCell.h"
#import "ServiceInfoCell.h"
#import "TimeLineCell.h"
#import "ReasonCell.h"

#import "TimeLineModel.h"

#define kNavBarHeight 64
#define kSellerTelDefault @"96345"

@interface OrderDetailCancelViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)TimeLineModel *timeModel;

@property(strong,nonatomic)NSDateFormatter *formatterOut;

@property(strong,nonatomic)NSDateFormatter *formatterIn;

@end

@implementation OrderDetailCancelViewController 

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
    
    [self loadOrderTimeline];
    
    self.navigationItem.title = @"订单详情";
    
    [self initTableView];
}

#pragma mark - setUI方法
/**
 *  创建UITableView
 */
-(void)initTableView
{
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MTScreenW, MTScreenH - kNavBarHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    if (section == 0 || section == 1) {
        return 1;
    }
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger orderStatus = [self.orderInfor.status integerValue];
    
    if (indexPath.section == 0) {
        OrderServiceDetailCell *orderServiceDetailCell = [tableView dequeueReusableCellWithIdentifier:@"MTOrderServiceDetailCell"];
        if(orderServiceDetailCell == nil){
            orderServiceDetailCell = [OrderServiceDetailCell orderServiceDetailCell];
        }
        [orderServiceDetailCell setdataWithOrderModel:self.orderInfor];
        return orderServiceDetailCell;
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
        if (self.orderInfor.orgphone) {
            phoneStr = self.orderInfor.orgphone;
        }else if (self.orderInfor.orgtelnum){
            phoneStr = self.orderInfor.orgtelnum;
        }else{
            phoneStr = kSellerTelDefault;
        }
        
        sellerCell.detailTextLabel.text = phoneStr;
        return sellerCell;

    }else if (indexPath.section == 2 && indexPath.row == 1){
        ServiceInfoCell *serviceInfoCell = [ServiceInfoCell createServiceInfoCellWithTableView:tableView];
        serviceInfoCell.formatterIn = self.formatterIn;
        serviceInfoCell.formatterOut = self.formatterOut;
        [serviceInfoCell setDataWithOrderModel:self.orderInfor];
         return serviceInfoCell;
    }else if (indexPath.section == 3 && indexPath.row == 1){
        TimeLineCell *timeLineCell = [tableView dequeueReusableCellWithIdentifier:@"MTTimeLineCell"];
        if (timeLineCell == nil)
            timeLineCell =  [TimeLineCell timeLineCell];
        timeLineCell.item = self.timeModel;
        
        return timeLineCell;
        
    }else if (indexPath.section == 4 && indexPath.row == 1){
        ReasonCell *reasonCell = [[ReasonCell alloc] createReasonCellWithTableView:tableView];
        
        if (orderStatus >= 50 && orderStatus <= 59) {
            reasonCell.content = self.orderInfor.wqxyy;
        }else if (orderStatus >= 60 && orderStatus <= 69){
            reasonCell.content = self.orderInfor.wqxyy;
        }
        
        return reasonCell;
    }else{
        UITableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"titleCellId"];
        if (!titleCell) {
            titleCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"titleCellId"];
            titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                if (orderStatus >= 50 && orderStatus <= 59) {
                    titleStr = @"取消原因";
                }else if (orderStatus >= 60 && orderStatus <= 69){
                   titleStr = @"拒单原因";
                }
                break;
            default:
                titleStr = @"";
                break;
        }
        titleCell.textLabel.text = titleStr;
        return titleCell;
    }
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1) {
        return 55;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        return 240;
    }else if (indexPath.section == 3 && indexPath.row == 1){
        UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }else if (indexPath.section == 4 && indexPath.row == 1){
       static ReasonCell *reasonCell = nil;
        if (!reasonCell) {
          reasonCell = [[ReasonCell alloc] createReasonCellWithTableView:tableView];
        }
        
        NSInteger orderStatus = [self.orderInfor.status integerValue];
        if (orderStatus >= 50 && orderStatus <= 59) {
            reasonCell.content = self.orderInfor.wqxyy;
        }else if (orderStatus >= 60 && orderStatus <= 69){
            reasonCell.content = self.orderInfor.wqxyy;
        }
        
        return reasonCell.cellHeight;
    }
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 1) {
        return;
    }
    
    NSString *phoneStr;
    if (self.orderInfor.orgphone) {
        phoneStr = self.orderInfor.orgphone;
    }else if (self.orderInfor.orgtelnum){
        phoneStr = self.orderInfor.orgtelnum;
    }else{
        phoneStr = kSellerTelDefault;
    }
    
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phoneStr]];
    [[UIApplication sharedApplication] openURL:url];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

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

@end
