//
//  EvaluationItemCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/3.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "EvaluationItemCell.h"
#define textPadding 40

#define bottom 20
@implementation EvaluationItemCell

- (void)awakeFromNib
{
    self.contentLab.editable = NO;
    self.contentLab.textColor = HMColor(245, 184, 84);
    self.contentLab.userInteractionEnabled = NO;
    self.contentLab.scrollEnabled = NO;
    self.contentLab.backgroundColor = [UIColor clearColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.contentLab.attributedText = [[NSAttributedString alloc] initWithString:@"饮食治疗要适量控制 能量 及食盐量，降 低脂肪和胆固醇的摄入水平，控制体重，防止或纠正肥胖，利尿排钠，调节血容量，保护 心 、 脑、肾血 管系统功能。采用低脂肪低胆固醇、低钠、高维生素、适量蛋白质和能量饮食。" attributes:attributes];
    self.contentLab.autoresizesSubviews = YES;
    self.contentLab.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    CGFloat maxW = MTScreenW - 20;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [self.contentLab.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    self.contentLab.height =textSize.height;

    self.height = textSize.height + textPadding + bottom;
    self.evaView.userInteractionEnabled = NO;
    
    //    [self.queryEva setImage:[UIImage imageNamed:@"second_normal.png"] forState:UIControlStateNormal];//给button添加image
    //    self.queryEva.imageEdgeInsets = UIEdgeInsetsMake(0,MTScreenW - 30,0, 10);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    
    self.headIcon.layer.cornerRadius = self.headIcon.width/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
