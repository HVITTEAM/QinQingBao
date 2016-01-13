//
//  AddressInfoCell.m
//  QinQingBao
//
//  Created by Dual on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "AddressInfoCell.h"

@implementation AddressInfoCell

+ (AddressInfoCell *)addressInfoCell {
    AddressInfoCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AddressInfoCell" owner:self options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)setItem:(MallAddressModel *)item
{
    self.name.text = item.true_name;
    self.phone.text = item.mob_phone;
    self.address.text = [NSString stringWithFormat:@"%@%@",item.area_info,item.address];
    self.chooseLable.alpha = [item.is_default integerValue];
    self.chooseBtn.alpha = [item.is_default integerValue];
}


@end
