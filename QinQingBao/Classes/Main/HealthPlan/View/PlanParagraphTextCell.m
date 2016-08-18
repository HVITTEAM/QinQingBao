//
//  ParagraphTextCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PlanParagraphTextCell.h"

@implementation PlanParagraphTextCell

+ (PlanParagraphTextCell*) planParagraphTextCell
{
    PlanParagraphTextCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanParagraphTextCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)setTitle:(NSString *)title withValue:(NSString *)value
{
    self.titleLab.text = title;
    if (value && value.length > 0)
        [self setTextValue:value];
}

-(void)setTextValue:(NSString *)textValue
{
    _textValue = textValue;
    self.textLab.userInteractionEnabled = NO;
    self.textLab.text = self.textValue;
    CGSize size = [self.textLab sizeThatFits:CGSizeMake(MTScreenW - 40, MAXFLOAT)];
    self.textLab.height = size.height;
    self.height = CGRectGetMaxY(self.textLab.frame);
}

@end
