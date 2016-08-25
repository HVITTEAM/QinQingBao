//
//  ParagraphTextCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/4/18.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PlanParagraphTextCell.h"

@interface PlanParagraphTextCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headJmg;

@end

@implementation PlanParagraphTextCell

+ (PlanParagraphTextCell*) planParagraphTextCell
{
    PlanParagraphTextCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"PlanParagraphTextCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)setTitle:(NSString *)title withValue:(NSString *)value
{
    self.headJmg.image = [UIImage imageNamed:title];
    self.titleLab.text = title;
    [self setTextValue:value];
}

-(void)setTextValue:(NSString *)textValue
{
    if (!textValue) {
        textValue = @"无";
    }
    _textValue = textValue;
    self.textLab.userInteractionEnabled = NO;
    self.textLab.text = self.textValue;
    CGSize size = [self.textLab sizeThatFits:CGSizeMake(MTScreenW - 40, MAXFLOAT)];
    self.textLab.height = size.height;
    self.height = CGRectGetMaxY(self.textLab.frame);
}

@end
