//
//  TimeLineCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/27.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "TimeLineCell.h"
#import "TimeLineViewControl.h"

@implementation TimeLineCell 

+ (TimeLineCell*) timeLineCell
{
    TimeLineCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"TimeLineCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 *1.提交订单 wctime
 2.支付成功 paytime
 3.服务开始 wjdtime
 4.服务完成 wjstime
 5.提出申请退款时间work_add_time
 6.卖家处理时间work_seller_time
 7.管理员处理时间work_admin_time
 *
 *  @param item <#item description#>
 */
-(void)setItem:(OrderModel *)item
{
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    if (item.wctime)//工单创建时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 预约成功",item.wctime] atIndex:0];
    }
    if (item.wjdtime)//接单时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 服务接单",item.wjdtime] atIndex:0];
    }
    if (item.worgpjtime)//服务商评价时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 服务完成",item.worgpjtime] atIndex:0];
    }
    if (item.pay_time)//支付完成
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 结算完成",item.pay_time] atIndex:0];
    }
    if (item.wpjtime)//评价时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已评价",item.wpjtime] atIndex:0];
    }
    if (item.wqxtime && [item.status floatValue] > 50 && [item.status floatValue] < 59)// 工单取消申请时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 取消订单",item.wqxtime] atIndex:0];
    }
    if (item.wjudtime)//拒单时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已拒订单",item.wjudtime] atIndex:0];
    }
//    if (item.wjstime)//结束时间
//    {
//        [timeArr insertObject:[NSString stringWithFormat:@"%@ 订单完成",item.wjstime] atIndex:0];
//    }

//    NSArray *descriptions = @[@"2015-06-18 18:19:30 正在处理",@"2015-06-18 18:01:10 已分派",@"2015-06-18 16:19:30 订单确认",@"2015-06-18 15:11:10 下单成功"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil
                                                           andTimeDescriptionArray:[timeArr copy]
                                                                  andCurrentStatus:1
                                                                          andFrame:CGRectMake(-30, 10, self.width - 30, 35 * timeArr.count)];
    [self addSubview:timeline];
    
    self.height = CGRectGetMaxY(timeline.frame);
}

@end
