//
//  ServiceDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderServiceDetailCell.h"

@implementation OrderServiceDetailCell


+(OrderServiceDetailCell *) orderServiceDetailCell
{
    OrderServiceDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderServiceDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setdataWithItem:(ServiceItemModel *)itemInfo
{
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,itemInfo.item_url]];
    [self.serviceIcon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.serviceTitle.text = itemInfo.orgname;
    self.serviceDesc.text = itemInfo.tname;
    self.servicePrice.text = [itemInfo.price isEqualToString:@"0"] || [itemInfo.price isEqualToString:@"0.00"] ? @"面议" : [NSString stringWithFormat:@"￥%.01f",[itemInfo.price floatValue]];
}


@end
