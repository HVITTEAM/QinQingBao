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

- (void)setItem:(HealthModel *)item
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

- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value
{
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) return;
    
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
    }
}

- (void)setupLabel:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        NSString *string                            = [NSString stringWithFormat:@"%.0f 次/分钟",value];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        float length = [NSString stringWithFormat:@"%.0f",value].length;
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
        
        label.attributedText = attributedString;
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.0f", resValue];
    }
    
    flag++;
    
}


@end
