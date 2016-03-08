//
//  CommonGoodsDetailMiddleCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsDetailMiddleCell.h"

@implementation CommonGoodsDetailMiddleCell

+(CommonGoodsDetailMiddleCell *) commonGoodsDetailMiddleCell
{
    CommonGoodsDetailMiddleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsDetailMiddleCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}


-(void)initView
{
    self.topLine.backgroundColor = [UIColor colorWithRGB:@"e2e2e2"];
    
    _button.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _button.layer.borderWidth = 0.5f;
    _button.layer.cornerRadius = 4;
    [_button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];
    
}

//修改by swy
-(void)buttonClick:(UIButton *)sender
{
    if (self.refundOperation && ![sender.titleLabel.text isEqualToString:@"退货退款中"]) {
        self.refundOperation(self);
    }
    //    NSURL *url  = [NSURL URLWithString:@"telprompt://4001512626"];
    //
    //    [[UIApplication sharedApplication] openURL:url];
}

-(void)setitemWithData:(ExtendOrderGoodsModel *)item
{
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.goods_image_url]];
    [self.goodsIconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
    self.goodsTitleLab.text = item.goods_name;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",item.goods_price];
    self.countLab.text = item.goods_num;
    if (item && item.extend_refund)
    {
        self.button.layer.borderWidth = 0;
        self.button.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.button setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
        [self.button setTitle:@"退货退款中" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.button setTitle:@"退货/退款" forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
