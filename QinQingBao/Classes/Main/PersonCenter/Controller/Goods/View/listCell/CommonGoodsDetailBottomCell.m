//
//  CommonGoodsDetailBottomCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsDetailBottomCell.h"
#import "CommonOrderModel.h"

@implementation CommonGoodsDetailBottomCell


+(CommonGoodsDetailBottomCell *) commonGoodsDetailBottomCell
{
    CommonGoodsDetailBottomCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsDetailBottomCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
    self.paysnLab.text = item.order_sn;
    self.alisnLab.text = item.pay_sn;

    self.dealLab.text = [MTDateHelper getDaySince1970:item.finnshed_time dateformat:@"yyyy-MM-dd HH:MM:ss"];
    self.createLab.text =  [MTDateHelper getDaySince1970:item.add_time dateformat:@"yyyy-MM-dd HH:MM:ss"];
    self.paytimeLab.text =  [MTDateHelper getDaySince1970:item.payment_time dateformat:@"yyyy-MM-dd HH:MM:ss"];
    self.deliverLab.text = [MTDateHelper getDaySince1970:item.delay_time dateformat:@"yyyy-MM-dd HH:MM:ss"];
}

@end
