//
//  CustomInfoCell.m
//  QinQingBao
//
//  Created by shi on 16/7/4.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CustomInfoCell.h"

@implementation CustomInfoCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"customInfoCell";
    CustomInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomInfoCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
