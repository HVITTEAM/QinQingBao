//
//  MallEvaCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MallEvaCell.h"

@implementation MallEvaCell


+(MallEvaCell *)mallEvaCell
{
    MallEvaCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MallEvaCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.height = 140;
    [cell initView];
    return cell;
}

-(void)initView
{
    _button.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _button.layer.borderWidth = 0.5f;
    _button.layer.cornerRadius = 4;
    [_button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];

}

-(void)buttonClick:(UIButton *)sender
{
    if (self.checkClick)
        self.checkClick(sender);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
