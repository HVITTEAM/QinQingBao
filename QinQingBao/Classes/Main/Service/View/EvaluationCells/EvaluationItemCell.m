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


+ (EvaluationItemCell*) evaluationItemCell
{
    EvaluationItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationItemCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.contentLab.editable = NO;
    self.contentLab.textColor = HMColor(245, 184, 84);
    self.contentLab.userInteractionEnabled = NO;
    self.contentLab.scrollEnabled = NO;
    self.contentLab.backgroundColor = [UIColor clearColor];
}

- (void)setitemWithData:(EvaluationModel *)item
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 7;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.contentLab.attributedText = [[NSAttributedString alloc] initWithString:item.dis_con == nil ? @"默认好评" : item.dis_con attributes:attributes];
    self.contentLab.autoresizesSubviews = YES;
    self.contentLab.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    CGFloat maxW = MTScreenW - 20;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    CGSize textSize = [self.contentLab.attributedText boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    //    self.contentLab.height =textSize.height;
    
    self.height = textSize.height + textPadding + bottom;
    self.evaView.userInteractionEnabled = NO;
    
    float score = [item.wgrade floatValue];
    [self.evaView setScore:score/5 withAnimation:NO];
    
    self.headIcon.layer.cornerRadius = self.headIcon.width/2;
    self.nameLab.text = item.oldname;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
