//
//  ServiceListCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "GoodsCell.h"
#import "GoodsInfoModel.h"

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

- (void)setitemWithData:(GoodsInfoModel *)item
{
    self.evaLab.textColor = [UIColor colorWithRGB:@"666666"];
    self.serviceTitleLab.text = item.goods_name;
    self.serviceDetailLab.text = [NSString stringWithFormat:@"￥%@",item.goods_price];
    self.serviceDetailLab.textColor = [UIColor colorWithRGB:@"dd2726"];
    float score = [item.evaluation_good_star floatValue];
    
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
    self.distanceLab.text = [NSString stringWithFormat:@"销量%@件",item.goods_salenum];
    self.distanceLab.textColor = [UIColor colorWithRGB:@"666666"];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",item.goods_image_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
