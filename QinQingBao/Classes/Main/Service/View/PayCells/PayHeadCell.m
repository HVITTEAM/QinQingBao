//
//  PayHeadCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/9.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "PayHeadCell.h"

@implementation PayHeadCell


+ (PayHeadCell*) payHeadCell
{
    PayHeadCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"PayHeadCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)setItem:(ServiceItemModel *)item
{
    _item = item;
    self.titleLab.text = item.icontent;
}

-(void)setOrderItem:(OrderItem *)orderItem
{
    _orderItem = orderItem;
    self.priceLab.text = self.orderItem.wprice;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
