//
//  GoodsMiddleTopCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsMiddleTopCell.h"

@implementation GoodsMiddleTopCell


+(GoodsMiddleTopCell *) goodsMiddleTopCell
{
    GoodsMiddleTopCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsMiddleTopCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
//    CommonOrderModel *itemInfo = item.order_list[0];
    
    if ([item.order_state isEqualToString:@"0"])
        self.statusLab.text = @"已取消";
    else if ([item.order_state isEqualToString:@"10"])
        self.statusLab.text = @"未付款";
    else if ([item.order_state isEqualToString:@"20"])
        self.statusLab.text = @"已付款";
    else if ([item.order_state isEqualToString:@"30"])
        self.statusLab.text = @"已发货";
    else if ([item.order_state isEqualToString:@"40"])
        self.statusLab.text = @"交易完成";
}

@end
