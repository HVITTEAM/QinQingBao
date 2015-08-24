//
//  HealthTipCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/7/3.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//
#define textPadding 27

#define bottom 20

#import "HealthTipCell.h"

@implementation HealthTipCell


- (void)awakeFromNib {
    self.tipText.editable = NO;
    self.titleLab.textColor = HMColor(245, 184, 84);
    self.tipText.scrollEnabled = NO;
    self.tipText.backgroundColor = [UIColor clearColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.tipText.attributedText = [[NSAttributedString alloc] initWithString:@"饮食治疗要适量控制 能量 及食盐量，降 低脂肪和胆固醇的摄入水平，控制体重，防止或纠正肥胖，利尿排钠，调节血容量，保护 心 、 脑、肾血 管系统功能。采用低脂肪低胆固醇、低钠、高维生素、适量蛋白质和能量饮食。" attributes:attributes];
    self.tipText.autoresizesSubviews = YES;
    self.tipText.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    CGFloat maxW = MTScreenW - 20;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [self.tipText.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;

    self.height = textSize.height + textPadding + bottom;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
@end
