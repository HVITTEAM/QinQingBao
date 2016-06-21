//
//  CommonMarketCell.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonMarketCell.h"

@implementation CommonMarketCell


+ (CommonMarketCell*) commonMarketCell
{
    CommonMarketCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonMarketCell" owner:self options:nil] objectAtIndex:0];
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
