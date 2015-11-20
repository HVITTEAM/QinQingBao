//
//  OrderSubmitCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderSubmitCell.h"

@implementation OrderSubmitCell


+(OrderSubmitCell *) orderSubmitCell
{
    OrderSubmitCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderSubmitCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_background"]];
    return cell;
}

- (void)awakeFromNib
{
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setServiceDetailItem:(ServiceItemModel *)serviceDetailItem
{
    _serviceDetailItem = serviceDetailItem;
    self.totalPriceLabe.text = [NSString stringWithFormat:@"¥%@",serviceDetailItem.price];
}

- (IBAction)submitClickHandler:(id)sender
{
    self.payClick(sender);
}
@end
