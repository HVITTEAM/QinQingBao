//
//  CommonOrderGoodsEvaCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonOrderGoodsEvaCell.h"

@implementation CommonOrderGoodsEvaCell


+(CommonOrderGoodsEvaCell *) commonOrderGoodsEvaCell
{
    CommonOrderGoodsEvaCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonOrderGoodsEvaCell" owner:self options:nil] objectAtIndex:0];
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
