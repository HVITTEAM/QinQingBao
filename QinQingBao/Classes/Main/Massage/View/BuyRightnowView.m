//
//  PlaceOrderView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "BuyRightnowView.h"

@implementation BuyRightnowView

- (void)drawRect:(CGRect)rect
{
    self.orderRightnow.enabled = NO;
    self.orderRightnow.layer.cornerRadius = 4;
}

- (IBAction)orderRightnowClickHandler:(id)sender
{
    self.submitClick(sender);
}

-(void)setPrice:(NSString *)price time:(NSString *)time markPrice:(NSString *)markPrice
{
    self.priceLab.text = [NSString stringWithFormat:@"%@元",price];
    
    NSString *markpriceStr = [NSString stringWithFormat:@"非会员%@",markPrice];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, markpriceStr.length)];
    self.markPriceLab.attributedText = attri;

}
@end
