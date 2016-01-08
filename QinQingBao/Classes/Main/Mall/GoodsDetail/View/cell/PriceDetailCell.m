//
//  PriceDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PriceDetailCell.h"

@implementation PriceDetailCell


+(PriceDetailCell *)priceDetailCell
{
    PriceDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"PriceDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setItem
{
    NSString *str = @"99.00";
    NSString *string                            = [NSString stringWithFormat:@"￥%@",str];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14.f]
                             range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:14.f]
                             range:NSMakeRange(string.length - 2, 2)];
    
    self.priceLab.attributedText = attributedString;
    
    self.desLab.textColor = [UIColor colorWithRGB:@"f14950"];
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"￥234.00"];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid |NSUnderlineStyleSingle) range:NSMakeRange(0, 7)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 7)];
    self.oldPriceLab.attributedText = attri;
    self.height = 90;
}
@end
