//
//  CommonCouponsCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/20.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "CommonCouponsCell.h"

@implementation CommonCouponsCell

+ (CommonCouponsCell*) commonCouponsCell
{
    CommonCouponsCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonCouponsCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setCouponsItem:(CouponsModel *)couponsItem
{
    _couponsItem = couponsItem;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgview.layer.cornerRadius = 5;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bottomview.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bottomview.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bottomview.layer.mask = maskLayer;
    
    [self updateConstraintsIfNeeded];

}

- (void)layoutIfNeeded
{
    [super layoutIfNeeded];
}
@end
