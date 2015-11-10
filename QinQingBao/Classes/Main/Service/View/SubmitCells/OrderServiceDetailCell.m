//
//  ServiceDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/6.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderServiceDetailCell.h"

@implementation OrderServiceDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setdataWithItem:(ServiceItemModel *)itemInfo
{
    NSURL *iconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://ibama.hvit.com.cn/public/%@",itemInfo.item_url]];
    [self.serviceIcon sd_setImageWithURL:iconUrl placeholderImage:[UIImage imageWithName:@"placeholderImage"]];
    self.serviceTitle.text = itemInfo.tname;
    self.serviceDesc.text = itemInfo.icontent;
    self.servicePrice.text = [NSString stringWithFormat:@"￥%.01f",[itemInfo.price floatValue]];
}


@end
