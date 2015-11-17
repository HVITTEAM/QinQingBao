//
//  ServiceDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/9.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "ServiceDetailCell.h"

@implementation ServiceDetailCell

+(ServiceDetailCell *)serviceCell
{
    ServiceDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"ServiceDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    self.contentView.backgroundColor = HMGlobalBg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    self.timeLab.text = itemInfo.servicetime;
}

@end
