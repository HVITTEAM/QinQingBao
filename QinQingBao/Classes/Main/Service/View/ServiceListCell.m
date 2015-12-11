//
//  ServiceListCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceListCell.h"
#import "ServiceItemModel.h"

@implementation ServiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setitemWithData:(ServiceItemModel *)item
{
    if (!item.sumsell)
        self.sunSellLab.text = @"售出0单";
    else
        self.sunSellLab.text = [NSString stringWithFormat:@"售出%@单",item.sumsell];
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",item.price];
    self.serviceTitleLab.text = item.icontent;
    self.serviceDetailLab.text = item.orgname;
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
    
    //    if (item.distance)
    self.distanceLab.text = [NoticeHelper kilometre2meter:[item.distance floatValue]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://ibama.hvit.com.cn/public/%@",item.item_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
