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

- (void)awakeFromNib
{
    self.starView.userInteractionEnabled = NO;

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
   
    self.priceLab.text = [item.price isEqualToString:@"0"] || [item.price isEqualToString:@"0.00"] ? @"面议" : [NSString stringWithFormat:@"￥%@",item.price];
    CGSize size = [self.priceLab.text sizeWithAttributes:@{NSFontAttributeName:self.priceLab.font}];
    self.priceLabWidth.constant = size.width;
    
    self.serviceTitleLab.text = item.orgname;

    //设置title宽度
    self.titleLabWidth.constant = CGRectGetMinX(self.priceLab.frame);

    self.serviceDetailLab.text = item.tname;
    float score = [item.sumgrad floatValue]/[item.sumdis floatValue];
    
    if (score >= 0 && score <= 5)
        [self.starView setScore:score/5 withAnimation:NO];
    else
        [self.starView setScore:0 withAnimation:NO];

    self.distanceLab.text = [NoticeHelper kilometre2meter:[item.distance floatValue]];
    self.distanceLab.textColor = MTNavgationBackgroundColor;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.item_url]];
    [self.iconImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
}

@end
