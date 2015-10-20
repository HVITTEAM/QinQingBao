//
//  BankCardCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/8/26.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "BankCardCell.h"

@implementation BankCardCell

- (void)awakeFromNib {
 
    self.backgroundColor = HMGlobalBg;
    self.bgView.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
