//
//  VideoCell.m
//  QinQingBao
//
//  Created by 董徐维 on 15/9/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "VideoCell.h"

@implementation VideoCell


+(VideoCell *)videoCell
{
    VideoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
