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
-(void)setItem:(TimeLineModel *)item
{
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    if (item.wctime && ![item.wctime isEqualToString:@"0000-00-00"])//提交订单
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 提交订单",item.wctime] atIndex:0];
    }
    if (item.wqxtime && ![item.wqxtime isEqualToString:@"0000-00-00"])//取消订单
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 取消订单",item.wqxtime] atIndex:0];
    }
    if (item.pay_time && ![item.pay_time isEqualToString:@"0000-00-00"])//支付成功
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 支付成功",item.pay_time] atIndex:0];
    }
    if (item.wjdtime && ![item.wjdtime isEqualToString:@"0000-00-00"])//服务开始
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 服务开始",item.wjdtime] atIndex:0];
    }
    if (item.wjstime && ![item.wjstime isEqualToString:@"0000-00-00"])//服务完成
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 服务完成",item.wjstime] atIndex:0];
    }
    
    if (item.container_sendtime && ![item.container_sendtime isEqualToString:@"0000-00-00"])//器皿配送时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已配送器皿",item.container_sendtime] atIndex:0];
    }
    
    if (item.report_uploadtime && ![item.report_uploadtime isEqualToString:@"0000-00-00"])//报告上传时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已上传报告",item.report_uploadtime] atIndex:0];
    }
    
    if (item.report_sendtime && ![item.report_sendtime isEqualToString:@"0000-00-00"])//报告发送时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已配送报告",item.report_sendtime] atIndex:0];
    }
    
    if (item.work_add_time && ![item.work_add_time isEqualToString:@"0000-00-00"])//申请退款
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 申请退款",item.work_add_time] atIndex:0];
    }
    if (item.seller_message && ![item.seller_message isEqualToString:@"0000-00-00"])// 申请成功/失败
    {
        if ([item.pay_staus floatValue] == 4 && [item.work_seller_state floatValue] == 2  && ![item.work_seller_time isEqualToString:@"0000-00-00"]) {
            [timeArr insertObject:[NSString stringWithFormat:@"%@ 退款成功",item.work_seller_time] atIndex:0];
        }
        else if ([item.pay_staus floatValue] == 5 && ![item.work_seller_time isEqualToString:@"0000-00-00"]) {
            [timeArr insertObject:[NSString stringWithFormat:@"%@ 退款失败",item.work_seller_time] atIndex:0];
        }
    }

//    NSArray *descriptions = @[@"2015-06-18 18:19:30 正在处理",@"2015-06-18 18:01:10 已分派",@"2015-06-18 16:19:30 订单确认",@"2015-06-18 15:11:10 下单成功"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil
                                                           andTimeDescriptionArray:[timeArr copy]
                                                                  andCurrentStatus:1
                                                                          andFrame:CGRectMake(-30, 10, MTScreenW - 30, 35 * timeArr.count)];
    [self addSubview:timeline];
    
    self.height = CGRectGetMaxY(timeline.frame);
}

@end
