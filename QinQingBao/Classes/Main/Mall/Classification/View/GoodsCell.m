//
//  ServiceListCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "GoodsCell.h"
#import "ServiceItemModel.h"

@implementation GoodsCell


+ (GoodsCell*) goodsCell
{
    GoodsCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodsCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setitemWithData:(ServiceItemModel *)item
{
    self.serviceTitleLab.text = @"Haier/海尔 BCD-249WDEGU1 249升 三门电冰箱 无霜智能 三温三控";
    self.serviceDetailLab.text = @"￥99.00";
    float score = [item.sumgrad floatValue]/[item.sumdis floatValue];
    
    self.starView.show_star = 10;
    self.starView.font_size = 18;
    self.starView.max_star = 100;
    self.starView.isSelect = NO;
    self.starView.empty_color = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
    self.starView.full_color = [UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
    if (score && score >= 0)
        self.starView.show_star = score *20;
    else
        self.starView.show_star = 0;
    self.distanceLab.text = @"销量100件";
    self.distanceLab.textColor = MTNavgationBackgroundColor;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.item_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
