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
    
    //时间区间
    if ([item.price_time_max isEqualToString:item.price_time_min])
        self.timeLab.text = [NSString stringWithFormat:@"%@分钟",item.price_time_max];
    else
        self.timeLab.text = [NSString stringWithFormat:@"%@-%@分钟",item.price_time_min,item.price_time_max];
    
    //非会员区间
    NSString *markpriceStr;
    if ([item.price_min isEqualToString:item.price_max])
        markpriceStr = [NSString stringWithFormat:@"非会员%@",item.price_min];
    else
        markpriceStr = [NSString stringWithFormat:@"非会员%@-%@",item.price_min,item.price_max];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:markpriceStr];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, markpriceStr.length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, markpriceStr.length)];
    self.sellLab.attributedText = attri;
    
    //会员价区间
    if ([item.price_mem_min isEqualToString:item.price_mem_max])
        self.priceLab.text = [NSString stringWithFormat:@"%@元",item.price_mem_max];
    else
        self.priceLab.text = [NSString stringWithFormat:@"%@-%@元",item.price_mem_min,item.price_mem_max];
    
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.item_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
