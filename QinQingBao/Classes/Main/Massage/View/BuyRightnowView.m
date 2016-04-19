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
    self.orderRightnow.layer.cornerRadius = 4;
}

- (IBAction)orderRightnowClickHandler:(id)sender
{
    self.submitClick(sender);
}

-(void)setPrice:(NSString *)price time:(NSString *)time
{
    self.priceLab.text = [NSString stringWithFormat:@"%@元/%@分钟",price,time];
}
@end
