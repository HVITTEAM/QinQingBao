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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
}

-(void)setItem:(OrderModel *)item
{
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    if (item.wctime)//工单创建时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 提交订单",item.wctime] atIndex:0];
    }
    if (item.wjdtime)//接单时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已受理",item.wjdtime] atIndex:0];
    }
    if (item.wjstime)//结束时间
    {
        [timeArr insertObject:[NSString stringWithFormat:@"%@ 已完成",item.wjstime] atIndex:0];
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
//    
//    NSArray *descriptions = @[@"2015-06-18 18:19:30 正在处理",@"2015-06-18 18:01:10 已分派",@"2015-06-18 16:19:30 订单确认",@"2015-06-18 15:11:10 下单成功"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil
                                                           andTimeDescriptionArray:[timeArr copy]
                                                                  andCurrentStatus:1
                                                                          andFrame:CGRectMake(-30, 10, self.width - 30, 35 * timeArr.count)];
    [self addSubview:timeline];
    
    self.height = CGRectGetMaxY(timeline.frame);
}

@end
