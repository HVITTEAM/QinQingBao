//
//  MassageServiceCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MassageServiceCell.h"

@implementation MassageServiceCell

+ (MassageServiceCell *)massageServiceCell {
    MassageServiceCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MassageServiceCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setItem:(MassageModel *)item
{
    _item = item;
    self.titleLab.text = item.iname;
    if ([item.price_time_max isEqualToString:item.price_time_min])
        self.timeLab.text = [NSString stringWithFormat:@"%@分钟",item.price_time_max];
    else
        self.timeLab.text = [NSString stringWithFormat:@"%@-%@分钟",item.price_time_min,item.price_time_max];
    self.sellLab.text = [NSString stringWithFormat:@"已售%@单",item.sell];
    
    if ([item.price_min isEqualToString:item.price_max])
        self.priceLab.text = [NSString stringWithFormat:@"%@元",item.price_time_max];
    else
        self.priceLab.text = [NSString stringWithFormat:@"%@-%@元",item.price_min,item.price_max];
    
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.item_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
