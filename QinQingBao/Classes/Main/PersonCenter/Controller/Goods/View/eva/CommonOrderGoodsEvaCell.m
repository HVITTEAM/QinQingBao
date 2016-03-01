//
//  CommonOrderGoodsEvaCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonOrderGoodsEvaCell.h"

@implementation CommonOrderGoodsEvaCell


+(CommonOrderGoodsEvaCell *) commonOrderGoodsEvaCell
{
    CommonOrderGoodsEvaCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonOrderGoodsEvaCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}


-(void)initView
{
    self.contentText.layer.borderColor = [[UIColor colorWithRGB:@"979797"] CGColor];
    self.contentText.layer.borderWidth = 0.5f;
}

- (IBAction)starClickeHandler:(id)sender
{
    UIButton *btn = sender;
    btn.selected =  !btn.selected;
    if (btn.selected)
    {
        for (int i = 100; i < btn.tag+1; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view viewWithTag:i];
            otherBtn.selected =  YES;
        }
        maxStar = btn.tag - 99;
    }
    else
    {
        for (int i =  btn.tag + 1; i < 105; i++)
        {
            UIButton *otherBtn = (UIButton*)[self.view viewWithTag:i];
            otherBtn.selected =  NO;
        }
        maxStar = btn.tag - 100;
    }
}

-(void)setitemWithData:(ExtendOrderGoodsModel *)item
{
    _goodsItem = item;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.goods_image_url]];
    [self.icon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
    
    self.titleLab.text = item.goods_name;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",item.goods_price];
}

-(NSString *)getEvaContent
{
    NSString *str = [NSString stringWithFormat:@"%@-%.00f-%@",self.goodsItem.goods_id,maxStar,self.contentText.text];
    return str;
}


@end
