//
//  CouponsCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CouponsCell.h"

@implementation CouponsCell

- (IBAction)clickHandler:(id)sender
{
    self.selectBtn.selected = !self.selectBtn.selected;
}

+ (CouponsCell*) couponsCell
{
    CouponsCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponsCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.bgView.layer.cornerRadius = 4;
    self.selectBtn.userInteractionEnabled = NO;
}

-(void)setBtnSelected:(BOOL)selected
{
    self.selectBtn.selected = selected;
}

-(void)setCouponsModel:(CouponsModel *)couponsModel
{
    _couponsModel = couponsModel;
    
     // 设置富文本的时候，先设置的先显示，后设置的，如果与先设置的样式不一致，是不会覆盖的，富文本设置的效果具有先后顺序，大家要注意
    
    NSString *string                            = [NSString stringWithFormat:@"￥%@",couponsModel.voucher_price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:16.f]
                             range:NSMakeRange(0, 1)];
    self.priceLab.attributedText = attributedString;
      self.titleLab.text = couponsModel.voucher_title;
    self.titleLab.textColor = [UIColor colorWithRGB:@"333333"];
    
    self.endtimeLab.text = [NSString stringWithFormat:@"有效期至:%@", [MTDateHelper getDaySince1970:couponsModel.voucher_end_date dateformat:nil]];
    self.endtimeLab.textColor = [UIColor colorWithRGB:@"666666"];
    self.limitLab.text = [NSString stringWithFormat:@"满%@元使用",couponsModel.voucher_limit];
    self.limitLab.textColor = [UIColor colorWithRGB:@"666666"];
    self.owerLab.textColor = [UIColor colorWithRGB:@"666666"];
    
    if ([couponsModel.voucher_price floatValue] <= 10)
    {
        self.priceLab.textColor = HMColor(37, 154, 218);
        self.sublab.textColor = HMColor(37, 154, 218);
        self.bgImgView.image = [UIImage imageNamed:@"coupons_3.png"];
    }
    else if([couponsModel.voucher_price floatValue] <= 30)
    {
        self.priceLab.textColor = HMColor(243, 127, 24);
        self.sublab.textColor = HMColor(243, 127, 24);
        self.bgImgView.image = [UIImage imageNamed:@"coupons_1.png"];
    }
    else
    {
        self.priceLab.textColor = HMColor(229, 78, 61);
        self.sublab.textColor = HMColor(229, 78, 61);
        self.bgImgView.image = [UIImage imageNamed:@"coupons_2.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
