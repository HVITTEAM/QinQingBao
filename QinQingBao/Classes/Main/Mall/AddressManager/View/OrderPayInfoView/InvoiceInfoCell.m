//
//  InvoiceInfoCell.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "InvoiceInfoCell.h"

@implementation InvoiceInfoCell

+ (InvoiceInfoCell *)invoiceInfoCell {
    InvoiceInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"InvoiceInfoCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
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
