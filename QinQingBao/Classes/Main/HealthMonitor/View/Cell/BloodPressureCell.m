//
//  BloodPressureCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/24.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "BloodPressureCell.h"

@implementation BloodPressureCell


+(BloodPressureCell *)bloodPressureCell
{
    BloodPressureCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"BloodPressureCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setItem:(HealthDataModel *)item
{
    _item = item;
    
    NSString *string                            = [NSString stringWithFormat:@"%@ mmHg",item.heartrate_min];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:HMColor(43, 139, 39)
                             range:NSMakeRange(0, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:22.f]
                             range:NSMakeRange(0, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12.f]
                             range:NSMakeRange(2, 5)];
    
    self.hightLab.attributedText = attributedString;
    
    NSString *string1                            = [NSString stringWithFormat:@"%@ mmHg",item.heartrate_max];
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:string1];
    
    // 设置富文本样式
    
    [attributedString1 addAttribute:NSForegroundColorAttributeName
                              value:HMColor(43, 139, 39)
                              range:NSMakeRange(0, 3)];
    
    [attributedString1 addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:22.f]
                              range:NSMakeRange(0, 3)];
    
    [attributedString1 addAttribute:NSFontAttributeName
                              value:[UIFont systemFontOfSize:12.f]
                              range:NSMakeRange(3, 5)];
    
    self.lowLab.attributedText = attributedString1;
    NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.heart_time];
    self.timeLab.text = time;
}


@end
