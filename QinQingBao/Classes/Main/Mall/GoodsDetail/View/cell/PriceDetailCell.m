//
//  PriceDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PriceDetailCell.h"

@implementation PriceDetailCell


+(PriceDetailCell *)priceDetailCell
{
    PriceDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"PriceDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setItem:(GoodsInfoModel *)goodsInfo
{
    if (!goodsInfo)
        return;
    NSString *priceStr                          = [NSString stringWithFormat:@"￥%@",goodsInfo.promotion_price ? goodsInfo.promotion_price : goodsInfo.goods_price];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:priceStr];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14.f]
                             range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14.f]
                             range:NSMakeRange(priceStr.length - 2, 2)];
    
    //现价
    self.priceLab.attributedText = attributedString;
    
    CGRect tmpRect = [self.priceLab.text boundingRectWithSize:CGSizeMake(MTScreenW - 20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.priceLab.font,NSFontAttributeName, nil] context:nil];
    
    self.oldPriceLeftpadding.constant = (tmpRect.size.width - self.priceLab.width) + 30;
    //描述
    self.desLab.textColor = [UIColor colorWithRGB:@"f14950"];
    
    if (goodsInfo.goods_marketprice)
    {
        NSString *markpriceStr                            = [NSString stringWithFormat:@"￥%@  ",goodsInfo.goods_marketprice];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length-1)];
        [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, markpriceStr.length-1)];
        //市场价
        self.oldPriceLab.attributedText = attri;
    }
    if ([goodsInfo.goods_marketprice isEqualToString:goodsInfo.goods_price])
        self.oldPriceLab.hidden = YES;
    
    //快递
    self.expressLab.text                       = [NSString stringWithFormat:@"快递: %@",goodsInfo.goods_freight];
    //销量
    self.sellCount.text                        = [NSString stringWithFormat:@"销量 %@ 笔",goodsInfo.goods_salenum];
    //库存
    self.stockLab.text                         = [NSString stringWithFormat:@"库存: %@",goodsInfo.goods_storage];
    
    self.height = 90;
}
@end
