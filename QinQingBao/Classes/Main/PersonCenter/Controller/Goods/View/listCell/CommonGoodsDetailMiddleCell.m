//
//  CommonGoodsDetailMiddleCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsDetailMiddleCell.h"

@implementation CommonGoodsDetailMiddleCell

+(CommonGoodsDetailMiddleCell *) commonGoodsDetailMiddleCell
{
    CommonGoodsDetailMiddleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsDetailMiddleCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)setitemWithData:(CommonGoodsModel *)item
{
    
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
