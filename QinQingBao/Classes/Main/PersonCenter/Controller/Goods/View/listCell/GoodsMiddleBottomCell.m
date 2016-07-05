//
//  GoodsMiddleBottomCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsMiddleBottomCell.h"

@implementation GoodsMiddleBottomCell


+(GoodsMiddleBottomCell *) goodsMiddleBottomCell
{
    GoodsMiddleBottomCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsMiddleBottomCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}

-(void)initView
{
    self.bottomLine.backgroundColor = [UIColor colorWithRGB:@"e2e2e2"];
    
    _cantactBtn.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _cantactBtn.layer.borderWidth = 0.5f;
    _cantactBtn.layer.cornerRadius = 4;
    [_cantactBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_cantactBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_cantactBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_cantactBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_cantactBtn setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];

    _telBtn.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _telBtn.layer.borderWidth = 0.5f;
    _telBtn.layer.cornerRadius = 4;
    [_telBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_telBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_telBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_telBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_telBtn setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];
}

-(void)buttonClick:(UIButton *)sender
{
    NSURL *url  = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",ShopTel1]];
    
    [[UIApplication sharedApplication] openURL:url];
}


-(void)setitemWithData:(CommonGoodsModel *)item
{
//    CommonOrderModel *itemInfo = item.order_list[0];
    
    //总金额
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",item.order_amount];
    self.priceLab.textColor = [UIColor colorWithRGB:@"dd2726"];
    //运费
    self.feeLab.text = [NSString stringWithFormat:@"￥%@",item.shipping_fee];
}


@end
