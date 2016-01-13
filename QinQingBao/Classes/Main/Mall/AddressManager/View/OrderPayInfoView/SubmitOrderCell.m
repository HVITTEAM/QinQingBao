//
//  SubmitOrderCell.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SubmitOrderCell.h"

@implementation SubmitOrderCell

+(SubmitOrderCell *)submitOrder {
    SubmitOrderCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SubmitOrderCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = HMGlobalBg;
    cell.submitBtn.backgroundColor = [UIColor colorWithRed:232/255.0 green:127/255.0 blue:32/255.0 alpha:1];
    return cell;
}

- (IBAction)submit:(UIButton *)sender {
    self.clickSubmit(sender);
}















- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
