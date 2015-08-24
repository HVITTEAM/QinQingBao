//
//  PromptCell.m
//  QinQingBao
//
//  Created by shi on 15/8/21.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#define textPadding 27

#define bottom 20

#import "PromptCell.h"

@implementation PromptCell

- (void)awakeFromNib {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:self.contentText attributes:attributes];
    self.contentLabel.autoresizesSubviews = YES;
    self.contentLabel.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    CGFloat maxW = MTScreenW - 20;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [self.contentLabel.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    self.height = textSize.height + textPadding + bottom;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
