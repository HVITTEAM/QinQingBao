//
//  HeartCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/19.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HeartCell.h"

@implementation HeartCell


+(HeartCell *)heartCell
{
    HeartCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"HeartCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)awakeFromNib
{
    //    self.bgView.layer.cornerRadius = 3;
    //    self.bgView.layer.borderColor = [[UIColor grayColor] CGColor];
    //    self.bgView.layer.borderWidth = 0.33;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItem:(HealthModel *)item
{
    _item = item;
    
    if (item.bloodsugar && [item.bloodsugar integerValue] > 0)
    {
        NSInteger strlength = item.bloodsugar.length;
        NSString *string                            = [NSString stringWithFormat:@"%@ mmol/L",item.bloodsugar];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        // 设置富文本样式
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:NSMakeRange(0, strlength)];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:22.f]
                                 range:NSMakeRange(0, strlength)];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12.f]
                                 range:NSMakeRange(strlength, string.length - strlength)];
        
        self.heartDataLabel.attributedText = attributedString;
    }
    if (item.bloodsugar_time)
    {
        NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.bloodsugar_time];
        self.time.text = time;
    }
}

@end
