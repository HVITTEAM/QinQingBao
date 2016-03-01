//
//  RefundCellBottom.m
//  QinQingBao
//
//  Created by shi on 16/2/29.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RefundCellBottom.h"

@implementation RefundCellBottom

- (void)awakeFromNib
{
    self.detailInfoBtn.layer.borderColor = HMColor(220, 220, 220).CGColor;
    self.detailInfoBtn.layer.borderWidth = 0.5f;
    self.detailInfoBtn.layer.cornerRadius = 7.0f;
    
}

+(RefundCellBottom *)refundCellBottomWithTableView:(UITableView *)tableView
{
    RefundCellBottom * cell = [tableView dequeueReusableCellWithIdentifier:@"refundCellBottom"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RefundCellBottom" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
