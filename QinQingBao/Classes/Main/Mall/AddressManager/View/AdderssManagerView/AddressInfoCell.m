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
    
    NSString *string  = @"";

    if ([item.is_default integerValue] == 1)
    {
        string = [NSString stringWithFormat:@"[默认地址]%@%@",item.area_info,item.address];
        // 设置富文本的时候，先设置的先显示，后设置的，如果与先设置的样式不一致，是不会覆盖的，富文本设置的效果具有先后顺序，大家要注意
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        
        // 设置富文本样式
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor redColor]
                                 range:NSMakeRange(0, 5)];
        
        self.address.attributedText = attributedString;
    }
    else
    {
        string = [NSString stringWithFormat:@"%@%@",item.area_info,item.address];
        self.address.text = string;
    }
   
    self.chooseLable.alpha = 0;
    self.chooseBtn.alpha = 0;
}


@end
