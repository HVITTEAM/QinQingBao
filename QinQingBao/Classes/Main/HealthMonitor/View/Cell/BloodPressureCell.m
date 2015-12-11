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
    if (item.systolic)
    {
        NSInteger strlength = item.systolic.length;
        NSString *string                            = [NSString stringWithFormat:@"%@ mmHg",item.systolic];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        // 设置富文本样式
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:HMColor(43, 139, 39)
                                 range:NSMakeRange(0, strlength)];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:22.f]
                                 range:NSMakeRange(0, strlength)];
        
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12.f]
                                 range:NSMakeRange(strlength, string.length - strlength)];
        
        self.hightLab.attributedText = attributedString;
    }
    
    if (item.diastolic) {
        
        NSInteger strlength1 = item.diastolic.length;
        
        NSString *string1                            = [NSString stringWithFormat:@"%@ mmHg",item.diastolic];
        NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:string1];
        
        // 设置富文本样式
        
        [attributedString1 addAttribute:NSForegroundColorAttributeName
                                  value:HMColor(43, 139, 39)
                                  range:NSMakeRange(0, strlength1)];
        
        [attributedString1 addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:22.f]
                                  range:NSMakeRange(0, strlength1)];
        
        [attributedString1 addAttribute:NSFontAttributeName
                                  value:[UIFont systemFontOfSize:12.f]
                                  range:NSMakeRange(strlength1, string1.length - strlength1)];
        
        self.lowLab.attributedText = attributedString1;
        NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.heart_time];
        self.timeLab.text = time;
    }
}


@end
