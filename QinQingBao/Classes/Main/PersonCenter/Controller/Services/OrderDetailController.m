//
//  OrderDetailController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/27.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderDetailController.h"
#import "ServiceItemModel.h"
#import "OrderHeadCell.h"
#import "TimeLineCell.h"


@interface OrderDetailController ()
{
    ServiceItemModel *serviceItem;
}

@end

@implementation OrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTableviewSkin];
    
    self.title = @"订单详情";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getServiceDetail];
}

/**
 *  订单详情VO
 *
 *  @param orderItem <#orderItem description#>
 */
-(void)setOrderItem:(OrderModel *)orderItem
{
    _orderItem = orderItem;
}

/**
 *  获取服务的内容
 */
-(void)getServiceDetail
{
    [CommonRemoteHelper RemoteWithUrl:URL_Iteminfo_data_byiid parameters:  @{@"iid" : self.orderItem.iid,
                                                                             @"client" : @"ios",
                                                                             @"key" : [SharedAppUtil defaultCommonUtil].userVO.key}
                                 type:CommonRemoteTypePost success:^(NSDictionary *dict, id responseObject) {
                                     serviceItem = [ServiceItemModel objectWithKeyValues:[dict valueForKey:@"datas"]];
                                     [self.tableView reloadData];
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     NSLog(@"发生错误！%@",error);
                                     [NoticeHelper AlertShow:@"获取失败!" view:self.view];
                                 }];
}

/**
 *  设置tableView属性
 */
-(void)initTableviewSkin
{
    self.tableView.backgroundColor = HMGlobalBg;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80;
            break;
        case 1:
        {
            if ( indexPath.row == 0)
                return 44;
            else
            {
                UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
                return cell.height;
            }
        }
            break;
        default:
            return 44;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 10;
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section)
    {
        case 0:
        {
            OrderHeadCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"MTOrderHeadCell"];
            
            if (orderCell == nil)
                orderCell =  [OrderHeadCell orderHeadCell];
            
            [orderCell setItem:serviceItem];
            
            cell = orderCell;
        }
            break;
        case 1:
        {
            if (indexPath.row == 0)
            {
                UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
                
                if (commonCell == nil)
                    commonCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
                commonCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
                commonCell.textLabel.text = @"订单跟踪:";
                commonCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:16];
                
                cell = commonCell;
            }
            else
            {
                TimeLineCell *timeLineCell = [tableView dequeueReusableCellWithIdentifier:@"MTTimeLineCell"];
                
                if (timeLineCell == nil)
                    timeLineCell =  [TimeLineCell timeLineCell];
                
                [timeLineCell setItem:self.orderItem];
                
                cell = timeLineCell;
            }
        }
            break;
        case 2:
        {
            UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"MTCommonCell"];
            
            if (commonCell == nil)
                commonCell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"MTCommonCell"];
            commonCell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
            
            if (indexPath.row == 0)
            {
                commonCell.textLabel.text = @"订单明细:";
                commonCell.textLabel.font = [UIFont fontWithName:@"Helvetica-Medium" size:16];
                return commonCell;
            }
            else if (indexPath.row == 1)
            {
                commonCell.textLabel.text = @"工单号";
                commonCell.detailTextLabel.text = self.orderItem.wcode;
            }
            else if (indexPath.row == 2)
            {
                commonCell.textLabel.text = @"服务商";
                commonCell.detailTextLabel.text = self.orderItem.orgname;
            }
            else if (indexPath.row == 3)
            {
                commonCell.textLabel.text = @"支付方式";
                commonCell.detailTextLabel.text = [self.orderItem.pay_type isEqualToString:@"1"] ? @"线上支付" : @"现金";
            }
            else if (indexPath.row == 4)
            {
                commonCell.textLabel.text = @"服务对象";
                commonCell.detailTextLabel.text = self.orderItem.wname;
            }
            else if (indexPath.row == 5)
            {
                commonCell.textLabel.text = @"联系方式";
                commonCell.detailTextLabel.text = self.orderItem.wtelnum;
            }
            else if (indexPath.row == 6)
            {
                commonCell.textLabel.text = @"服务地址";
                commonCell.detailTextLabel.text = self.orderItem.waddress;
            }
            else if (indexPath.row == 7)
            {
                commonCell.textLabel.text = @"原价";
                commonCell.detailTextLabel.text = self.orderItem.price;
            }
            else if (indexPath.row == 8)
            {
                commonCell.textLabel.text = @"优惠";
                commonCell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2f",[self.orderItem.price floatValue] - [self.orderItem.wprice floatValue]];
            }
            else if (indexPath.row == 9)
            {
                commonCell.textLabel.text = @"实付";
                commonCell.detailTextLabel.text = self.orderItem.wprice;
            }
            
            commonCell.textLabel.font = [UIFont systemFontOfSize:14];
            commonCell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            cell = commonCell;
        }
    }
    return cell;
}



@end
