//
//  EvaDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "EvaDetailCell.h"

@implementation EvaDetailCell


+ (EvaDetailCell*) evaDetailCell
{
    EvaDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
    return cell;
}
-(void)setItem:(OrderModel *)item
{
    _item = item;
    
    self.evaLab.editable = NO;
    self.evaLab.textColor = MTNavgationBackgroundColor;
    self.evaLab.userInteractionEnabled = NO;
    self.evaLab.scrollEnabled = NO;
    self.evaLab.backgroundColor = [UIColor clearColor];
    
    self.evaTimeLab.text = self.item.wpjtime;
    self.evaTimeLab.textColor = MTNavgationBackgroundColor;

    self.evaLab.text = self.item.dis_con;

    self.evaView.show_star = 10;
    self.evaView.font_size = 18;
    self.evaView.max_star = 100;
    self.evaView.isSelect = NO;
    self.evaView.empty_color = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
    self.evaView.full_color = [UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
    
    float score = [self.item.wgrade floatValue];
    if (score && score >= 0)
        self.evaView.show_star = score *20;
    else
        self.evaView.show_star = 0;
    
    self.evaWidth.constant = MTScreenW - 100;
    
    CGSize deSize = [self.evaLab sizeThatFits:CGSizeMake(MTScreenW - 100,CGFLOAT_MAX)];
    
    self.evaHeight.constant = deSize.height;
    self.height = deSize.height + self.evaLab.y + 10;
}



@end
