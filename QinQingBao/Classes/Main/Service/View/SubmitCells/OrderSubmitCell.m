//
//  OrderSubmitCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/8.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderSubmitCell.h"

@implementation OrderSubmitCell


+(OrderSubmitCell *) orderSubmitCell
{
    OrderSubmitCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderSubmitCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.submitBtn.layer.cornerRadius = 5;
    
    self.contentView.backgroundColor = HMGlobalBg;
    //
    //    // 1.取出背景view
    //    UIImageView *bgView = (UIImageView *)self.backgroundView;
    //    UIImageView *selectedBgView = (UIImageView *)self.selectedBackgroundView;
    //
    //        bgView.image = [UIImage resizedImage:@"common_card_background"];
    //        selectedBgView.image = [UIImage resizedImage:@"common_card_background_highlighted"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)submitClickHandler:(id)sender
{
    self.payClick(sender);
}
@end
