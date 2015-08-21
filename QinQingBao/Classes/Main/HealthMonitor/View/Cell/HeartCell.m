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
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.bgView.layer.borderWidth = 0.33;
    
    NSString *string                            = @"心率 71 次/分钟";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blackColor]
                             range:NSMakeRange(0, 2)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont fontWithName:@"Helvetica-Bold" size:16.f]
                             range:NSMakeRange(0, 2)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:HMColor(43, 139, 39)
                             range:NSMakeRange(2, 3)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:22.f]
                             range:NSMakeRange(2, 3)];
    
    self.heartDataLabel.attributedText = attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
