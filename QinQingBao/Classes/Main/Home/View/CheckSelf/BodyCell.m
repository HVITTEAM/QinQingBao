//
//  BodyCell.m
//  Test
//
//  Created by shi on 16/1/20.
//  Copyright © 2016年 mingenzb. All rights reserved.
//

#import "BodyCell.h"

@implementation BodyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // 设置选中时的标题颜色
    if (selected) {
        self.titleLb.textColor = HMColor(12, 167, 161);
    }else{
        self.titleLb.textColor = HMColor(102, 102, 102);
    }
}

@end
