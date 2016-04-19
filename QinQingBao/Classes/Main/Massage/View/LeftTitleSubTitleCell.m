//
//  LeftTitleSubTitleCell.m
//  QinQingBao
//
//  Created by shi on 16/4/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "LeftTitleSubTitleCell.h"

@implementation LeftTitleSubTitleCell

+(instancetype)createLeftTitleSubTitleCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)idx
{
    static NSString *leftTitleSubTitleCellId = @"leftTitleSubTitleCell";
    LeftTitleSubTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:leftTitleSubTitleCellId];
    if (!cell) {
        cell = [[LeftTitleSubTitleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:leftTitleSubTitleCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.detailTextLabel.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 10, self.detailTextLabel.frame.origin.y, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}

@end
