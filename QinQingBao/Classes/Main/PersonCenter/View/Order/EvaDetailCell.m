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
    //self.evaLab.textColor = MTNavgationBackgroundColor;
    self.evaLab.userInteractionEnabled = NO;
    self.evaLab.scrollEnabled = NO;
    self.evaLab.backgroundColor = [UIColor clearColor];
    
    self.evaTimeLab.text = self.item.wpjtime;
    //self.evaTimeLab.textColor = MTNavgationBackgroundColor;
    
    self.evaLab.text = self.item.dis_con;
    
    float score = [self.item.wgrade floatValue];
    if (score >= 0 && score <= 5)
        [self.evaView setScore:score/5 withAnimation:NO];
    else
        [self.evaView setScore:0 withAnimation:NO];
    
    self.evaWidth.constant = MTScreenW - 100;
    
    CGSize deSize = [self.evaLab sizeThatFits:CGSizeMake(MTScreenW - 100,CGFLOAT_MAX)];
    
    self.evaHeight.constant = deSize.height;
    self.height = deSize.height + self.evaLab.y + 10;
}



@end
