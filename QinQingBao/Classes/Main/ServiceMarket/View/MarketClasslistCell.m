//
//  MarketClasslistCell.m
//  QinQingBao
//
//  Created by shi on 16/8/15.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketClasslistCell.h"

@implementation MarketClasslistCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellid = @"marketClasslistCell";
    MarketClasslistCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MarketClasslistCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentImageView.layer.cornerRadius = 8.0f;
    self.contentImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
