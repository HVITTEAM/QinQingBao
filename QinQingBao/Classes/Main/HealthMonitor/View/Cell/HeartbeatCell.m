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
    
        NSString *string                            = [NSString stringWithFormat:@"%@ 次/分钟",item.heartrate_avg];
//    NSString *string                            = @"84 次/分钟";
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(0, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:22.f]
                             range:NSMakeRange(0, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12.f]
                             range:NSMakeRange(2, 5)];
    
    self.heartBeatLab.attributedText = attributedString;
    NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.ect_time];
    self.timeLab.text = time;
}

@end
