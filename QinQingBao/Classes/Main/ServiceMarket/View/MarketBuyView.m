//
//  MarketBuyView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "MarketBuyView.h"
#import "MassageModel.h"

@implementation MarketBuyView

- (void)drawRect:(CGRect)rect
{
    self.orderRightnow.enabled = NO;
    self.orderRightnow.layer.cornerRadius = 4;
}

- (IBAction)orderRightnowClickHandler:(id)sender
{
    self.submitClick(sender);
}

-(void)setItem:(MassageModel *)item
{
    _item = item;
    
    //会员价
    if (self.item.promotion_price && self.item.promotion_price.length > 0)
    {
        self.priceLab.text = [NSString stringWithFormat:@"%@元/位",self.item.promotion_price];
    }
    else  if ([self.item.price_mem_max floatValue] == [self.item.price_mem_min floatValue])
    {
        self.priceLab.text = [NSString stringWithFormat:@"%@元/位",self.item.price_mem_min];
    }
    else
    {
        self.priceLab.text = [NSString stringWithFormat:@"%@-%@元/位",self.item.price_mem_min,self.item.price_mem_max];
    }
    
    NSString *markpriceStr = [NSString stringWithFormat:@"%@元/位",self.item.price];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, markpriceStr.length)];
    self.markPriceLab.attributedText = attri;
}
@end