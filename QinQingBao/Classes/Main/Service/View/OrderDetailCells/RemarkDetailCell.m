//
//  RemarkDetailCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/17.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "RemarkDetailCell.h"

@implementation RemarkDetailCell

+ (RemarkDetailCell*) remarkDetailCell
{
    RemarkDetailCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"RemarkDetailCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)awakeFromNib
{
    self.contentView.backgroundColor = HMGlobalBg;
    self.remarkLab.enabled = NO;
    self.remarkLab.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setItemInfo:(ServiceItemModel *)itemInfo
{
    _itemInfo = itemInfo;
    self.remarkLab.text = itemInfo.remakr;
}

@end
