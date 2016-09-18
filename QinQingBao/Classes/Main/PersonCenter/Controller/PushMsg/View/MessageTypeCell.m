//
//  MessageTypeCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/1.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MessageTypeCell.h"

@implementation MessageTypeCell


+(MessageTypeCell *) messageTypeCell
{
    MessageTypeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTypeCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.badgeView.layer.cornerRadius = 5;
    cell.badgeView.hidden = YES;

    return cell;
}

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
