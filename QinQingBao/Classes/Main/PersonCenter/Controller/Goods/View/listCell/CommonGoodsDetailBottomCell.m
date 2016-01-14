//
//  CommonGoodsDetailBottomCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsDetailBottomCell.h"

@implementation CommonGoodsDetailBottomCell


+(CommonGoodsDetailBottomCell *) commonGoodsDetailBottomCell
{
    CommonGoodsDetailBottomCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsDetailBottomCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
    
}

@end
