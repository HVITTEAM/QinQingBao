//
//  PlaceOrderView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/6.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PlaceOrderHeadView.h"

@implementation PlaceOrderHeadView

- (void)drawRect:(CGRect)rect
{
    self.backgroundColor = HMGlobalBg;
    
    self.orderRightnow.layer.cornerRadius = 4;
}

- (IBAction)orderRightnowClickHandler:(id)sender
{
    self.submitClick(sender);
}

-(void)setPrice:(NSString *)price
{
    _price = price;
    self.priceLab.text = [NSString stringWithFormat:@"%@元",price];
}
@end
