//
//  RefundDetailViewController.m
//  QinQingBao
//
//  Created by shi on 16/2/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RefundDetailViewController.h"
#import "RefundStateCell.h"
#import "ReminderCell.h"
#import "RefundContentCell.h"
#import "RefundDetailModel.h"

static NSString *refundContentCellId = @"refundContent";

@interface RefundDetailViewController ()

@property(strong,nonatomic)NSMutableArray *dataProvider;      //中间 cell 的数据源

@property(strong,nonatomic)RefundDetailModel *refundDetail;   //退款详情数据 model

@end

@implementation RefundDetailViewController

-(instancetype)init
{
    self.hidesBottomBarWhenPushed = YES;
    self.title = @"退款详情";
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadRefundDetailData];
}

#pragma  mark -- 协议方法 --
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        //设置状态Cell
        static NSString *refundStateCellId = @"refundStateCell";
        RefundStateCell *cell = [tableView dequeueReusableCellWithIdentifier:refundStateCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RefundStateCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.stateLb.text = [self getStatusWithRefundDetailModel:self.refundDetail];
        cell.sumLb.text = [NSString stringWithFormat:@"￥%@",self.refundDetail.refund_amount];
        NSString *dateStr = [MTDateHelper getDaySince1970:self.refundDetail.add_time dateformat:@"yyyy-MM-dd hh:mm"];
        cell.timeLb.text = dateStr;
        return cell;
        
    }else if (indexPath.section == 2){
        //温馨提示 cell
        static NSString *reminderCellId = @"reminderCell";
        ReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:reminderCellId];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ReminderCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.contentStr = @"1、若提出退款申请后，商家无理由拒绝，请拨打客服热线；\n2、若退款申请成功后，在7个工作日内还未收到钱款，请拨打客服热线；\n3、客服热线：400 - 151 - 2626";
        return cell;
    }else{
        //退款内容 cell
        RefundContentCell *cell = [tableView dequeueReusableCellWithIdentifier:refundContentCellId];
        if (!cell) {
            cell = [[RefundContentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"refundContent"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.row) {
            case 0:
                cell.titleStr = @"商城名称";
                cell.contentStr = @"海予健康商城";
                break;
            case 1:
                cell.titleStr = @"退款类型";
                cell.contentStr = @"仅退款";
                if ([self.refundDetail.refund_type integerValue] == 1) {
                    cell.contentStr = @"退货退款";
                }
                break;
            case 2:
                cell.titleStr = @"退款原因";
                cell.contentStr = self.refundDetail.reason_info;
                break;
            case 3:
                cell.titleStr = @"退款说明";
                cell.contentStr = self.refundDetail.buyer_message;
                break;
            case 4:
                cell.titleStr = @"退款编号";
                cell.contentStr = self.refundDetail.refund_sn;
                break;
            default:
                break;
        }
        [cell setupCell];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static RefundContentCell *cell = nil;
    static ReminderCell *remindercell = nil;
    if (indexPath.section == 0) {
        return 108;
    }else if (indexPath.section == 2){
        if (!remindercell) {
            remindercell = [[[NSBundle mainBundle]loadNibNamed:@"ReminderCell" owner:nil options:nil] lastObject];
        }
        remindercell.contentStr = @"1、若提出退款申请后，商家无理由拒绝，请拨打客服热线；\n2、若退款申请成功后，在7个工作日内还未收到钱款，请拨打客服热线；\n3、客服热线：400 - 151 - 2626";
        return remindercell.height;
    }else{
        if (indexPath.row == 3) {
            if (!cell) {
                cell = [[RefundContentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"refundContent"];
            }
            cell.titleStr = @"退款说明";
            cell.contentStr = self.refundDetail.buyer_message;
            [cell setupCell];
            return cell.cellHeight > 40?cell.cellHeight:40;
        }
        return 40;
    }
}

#pragma  mark -- 网络相关方法 --
/**
 *  下载退款详情数据
 */
-(void)loadRefundDetailData
{
    NSDictionary *params = @{
                             @"key":[SharedAppUtil defaultCommonUtil].userVO.key,
                             @"client":@"ios",
                             @"refund_id":self.refundId,
                             };
    
    [CommonRemoteHelper RemoteWithUrl:URL_refund_return parameters:params type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
        
        if ([dict[@"code"] integerValue] == 17001) {
            [NoticeHelper AlertShow:dict[@"errorMsg"] view:self.view];
        }else if ([dict[@"code"] integerValue] == 0){
            
            NSDictionary *refundDict = dict[@"datas"];
            self.refundDetail =  [RefundDetailModel objectWithKeyValues:refundDict];
            [self.tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [NoticeHelper AlertShow:@"数据请求不成功" view:self.view];
    }];
}


#pragma  mark -- 内部方法 --
-(NSString *)getStatusWithRefundDetailModel:(RefundDetailModel *)model
{
    NSString *statusStr = nil;
    switch ([model.refund_state integerValue]) {
        case 1:
            statusStr = @"已申请退款";
            break;
        case 2:
            statusStr = @"商家审核中";
            break;
        case 3:
            if ([model.seller_state integerValue] == 2) {
                statusStr = @"退款申请成功";
            }else if ([model.seller_state integerValue] == 3){
                statusStr = @"退款申请失败";
            }
            break;
        default:
            statusStr = @"已申请退款";
    }
    return statusStr;
}


@end
