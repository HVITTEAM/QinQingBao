//
//  ServiceListCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/30.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceListCell.h"

@implementation ServiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self commonInit];
}

-(void)commonInit
{
    [self.starView setScore:0.3 withAnimation:YES];
    [self.starView setUserInteractionEnabled:NO];
}
@end
