//
//  CommonGoodsCellMiddle.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsCellMiddle.h"
#import "ExtendOrderGoodsModel.h"

@implementation CommonGoodsCellMiddle

+(CommonGoodsCellMiddle *) commonGoodsCellMiddle
{
    CommonGoodsCellMiddle * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsCellMiddle" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}

-(void)initView
{
    self.topLine.backgroundColor = [UIColor colorWithRGB:@"e2e2e2"];
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
    CommonOrderModel *itemInfo = item.order_list[0];
    ExtendOrderGoodsModel *goodsItem = itemInfo.extend_order_goods[0];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",goodsItem.goods_image_url]];
    [self.goodsIconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageNamed:@"placeholderImage.png"]];
    
    self.goodsTitleLab.text = goodsItem.goods_name;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",goodsItem.goods_price];
    self.countLab.text = goodsItem.goods_num;
}

@end
