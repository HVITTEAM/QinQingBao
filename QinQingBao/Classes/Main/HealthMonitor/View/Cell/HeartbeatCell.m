//
//  HeartbeatCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/4.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "HeartbeatCell.h"

@implementation HeartbeatCell

+(HeartbeatCell *)heartbeatCell
{
    HeartbeatCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HeartbeatCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}


- (void)setItem:(HealthDataModel *)item
{
    _item = item;
    
    if (item.heartrate_avg)
    {
        NSString *string                            = [NSString stringWithFormat:@"%@ 次/分钟",item.heartrate_avg];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        float length = item.heartrate_avg.length;
        // 设置富文本样式
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:NSMakeRange(0, length)];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:22.f]
                                 range:NSMakeRange(0, length)];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12.f]
                                 range:NSMakeRange(length, string.length - length)];
        
        self.heartBeatLab.attributedText = attributedString;
    }
    if (item.heart_time)
    {
        NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.heart_time];
        self.timeLab.text = time;
    }
}

@end
