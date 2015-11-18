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
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.backgroundColor = HMGlobalBg;
    self.evaView.show_star = 10;
    self.evaView.font_size = 20;
    
    self.evaView.empty_color = [UIColor colorWithRed:167.0f / 255.0f green:167.0f / 255.0f blue:167.0f / 255.0f alpha:1.0f];
    self.evaView.full_color = [UIColor colorWithRed:255.0f / 255.0f green:121.0f / 255.0f blue:22.0f / 255.0f alpha:1.0f];
    
//    Star *star1 = [[Star alloc] initWithFrame:CGRectMake(10, 7, 150.0f, 40.0f)];
//    star1.show_star = 10;
//    star1.font_size = 20;
//    [self addSubview:star1];
}

@end
