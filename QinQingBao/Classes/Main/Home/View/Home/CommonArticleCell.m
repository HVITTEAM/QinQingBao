//
//  CommonArticleCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonArticleCell.h"

@implementation CommonArticleCell

+(CommonArticleCell *)commonArticleCell
{
    CommonArticleCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonArticleCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
