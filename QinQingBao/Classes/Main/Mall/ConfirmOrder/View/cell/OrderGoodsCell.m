//
//  ServiceListCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderGoodsCell.h"
#import "MTShoppIngCarModel.h"

@implementation OrderGoodsCell


+ (OrderGoodsCell*) orderGoodsCell
{
    OrderGoodsCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderGoodsCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setitemWithData:(MTShoppIngCarModel *)goodsItem
{
    self.serviceTitleLab.text = goodsItem.item_info.full_name;
    self.serviceDetailLab.text = [NSString stringWithFormat:@"单价:%@",goodsItem.item_info.sale_price];
    self.distanceLab.text = [NSString stringWithFormat:@"数量:%@",goodsItem.count];
    NSURL *iconUrl = [NSURL URLWithString:goodsItem.item_info.icon];
    NSLog(@"sdsadddddddddd%@",goodsItem.item_info.icon);
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    
    self.height = 85;
}

@end
