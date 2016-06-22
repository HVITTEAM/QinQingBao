//
//  MarketOrderCell.m
//  QinQingBao
//
//  Created by shi on 16/6/21.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "MarketOrderCell.h"

@interface MarketOrderCell ()

@end

@implementation MarketOrderCell

+(instancetype)createCellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"marketOrderCell";
    MarketOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MarketOrderCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleLb.text = nil;
    self.subTitleLb.text = nil;
}

- (IBAction)leftBtnClickAction:(id)sender
{
    //TODO
}

- (IBAction)rightBtnClickAction:(id)sender
{
    //TODO
}

@end
