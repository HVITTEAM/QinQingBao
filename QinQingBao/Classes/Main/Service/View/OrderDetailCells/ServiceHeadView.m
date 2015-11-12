//
//  ServiceHeadView.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceHeadView.h"

@implementation ServiceHeadView


- (void)drawRect:(CGRect)rect
{
    self.bgview.height = 90;
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://ibama.hvit.com.cn/public/%@",itemInfo.item_url]];
    [self.icon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.title.text = itemInfo.tname;
    self.content.text = itemInfo.icontent;
    if (!itemInfo.sumsell)
        self.sum.text = @"成交0单";
    else
        self.sum.text = [NSString stringWithFormat:@"成交%@单",itemInfo.sumsell];
}
@end
