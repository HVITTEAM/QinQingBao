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
    
    if (score >= 0 && score <= 5)
        [self.starView setScore:score/5 withAnimation:NO];
    else
        [self.starView setScore:0 withAnimation:NO];
    
    self.distanceLab.text = [NSString stringWithFormat:@"销量%@件",item.goods_salenum];
    self.distanceLab.textColor = [UIColor colorWithRGB:@"666666"];
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"",item.goods_image_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
