//
//  EvaluationNoneCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/16.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "EvaluationNoneCell.h"

@implementation EvaluationNoneCell


+ (EvaluationNoneCell*) evanoneCell
{
    EvaluationNoneCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluationNoneCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.evaView setScore:0 withAnimation:NO];
    return cell;
}

- (void)awakeFromNib
{
    self.evaView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = HMGlobalBg;
}

-(void)setScore:(NSString *)score
{
    float fscore = [score floatValue];
    if (fscore >= 0 && fscore <= 5)
        [self.evaView setScore:fscore/5 withAnimation:NO];
    else
        [self.evaView setScore:0 withAnimation:NO];
  
//    self.strLab.text = [NSString stringWithFormat:@"%@分",score];
    self.strLab.text = @"暂无评分";

}

@end
