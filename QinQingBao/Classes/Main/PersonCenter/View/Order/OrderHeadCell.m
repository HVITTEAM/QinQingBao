//
//  OrderHeadCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/27.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderHeadCell.h"

@implementation OrderHeadCell

+ (OrderHeadCell*) orderHeadCell
{
    OrderHeadCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderHeadCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage resizedImage:@"common_card_middle_background.png"]];
    return cell;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)setItem:(ServiceItemModel *)item
{
    _item = item;
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_Img,item.item_url]];
    [self.headImg sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.titleLab.text = item.orgname;
    self.contentLab.text = item.tname;
    self.priceLab.text = [item.price isEqualToString:@"0"] || [item.price isEqualToString:@"0.00"] ? @"面议" : [NSString stringWithFormat:@"￥%@",item.price];
    
    //设置title宽度
    self.titleLabWidth.constant = CGRectGetMinX(self.priceLab.frame) - self.titleLab.x;
}
@end
