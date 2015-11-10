//
//  HeartCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/19.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "HeartCell.h"

@implementation HeartCell

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

- (void)setItem:(HealthDataModel *)item
{
    _item = item;
    
    NSString *string                            = [NSString stringWithFormat:@"%@ mmol/L",item.bloodglucose];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(0, 3)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:22.f]
                             range:NSMakeRange(0, 3)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:12.f]
                             range:NSMakeRange(3, 7)];
    
    self.heartDataLabel.attributedText = attributedString;
    
//    NSLog(@"%@",NSStringFromClass([item.uploadtime class]));
//    NSLog(@"%@",item.uploadtime);
    
        NSString *time                            = [NSString stringWithFormat:@"更新时间: %@",item.boolg_time];
        self.time.text = time;
}

@end
