//
//  CommonGoodsDetailHeadCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsDetailHeadCell.h"

@implementation CommonGoodsDetailHeadCell

+(CommonGoodsDetailHeadCell *) commonGoodsDetailHeadCell
{
    CommonGoodsDetailHeadCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsDetailHeadCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}

-(void)initView
{
    self.nameTitle.textColor = [UIColor colorWithRGB:@"666666"];
    self.addressLab.textColor = [UIColor colorWithRGB:@"666666"];
    self.telLab.textColor = [UIColor colorWithRGB:@"666666"];
    self.invoiceLab.textColor = [UIColor colorWithRGB:@"666666"];
    
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
    
}

@end
