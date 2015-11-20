//
//  CommonCouponsCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CommonCouponsCell.h"

@implementation CommonCouponsCell

- (void)awakeFromNib
{
    self.bgview.layer.cornerRadius = 5;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomview.layer.mask = maskLayer;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
}
@end
