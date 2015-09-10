//
//  CommonOrderCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonOrderCell.h"

@implementation CommonOrderCell

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - 调整子控件的位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topSapce.backgroundColor = HMColor(234, 234, 234);
    self.bottomSpace.backgroundColor = HMColor(234, 234, 234);
    
    self.deleteBtn.layer.borderWidth = 1;
    self.deleteBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    self.deleteBtn.layer.cornerRadius = 8;
}


- (IBAction)deleteBtnClickHandler:(id)sender
{
    self.deleteClick(sender);
}
@end
