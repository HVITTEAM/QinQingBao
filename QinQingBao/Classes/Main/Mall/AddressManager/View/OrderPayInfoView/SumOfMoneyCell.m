//
//  SumOfMoneyCell.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SumOfMoneyCell.h"

@implementation SumOfMoneyCell

+ (SumOfMoneyCell *)sumOfMoneyCell {
    SumOfMoneyCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SumOfMoneyCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
