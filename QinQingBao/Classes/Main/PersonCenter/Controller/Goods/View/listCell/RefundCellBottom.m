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
    [self.detailInfoBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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

-(void)setItemWithRefundData:(RefundListModel *)item
{
    switch ([item.refund_state integerValue]) {
        case 1:
            [self.detailInfoBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            break;
        case 2:
            [self.detailInfoBtn setTitle:@"退款详情" forState:UIControlStateNormal];
            break;
        case 3:
            if ([item.seller_state integerValue] == 2) {
                [self.detailInfoBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }else if ([item.seller_state integerValue] == 3){
                [self.detailInfoBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            }
            break;
        default:
            [self.detailInfoBtn setTitle:@"退款详情" forState:UIControlStateNormal];
    }
}

-(void)buttonClick:(UIButton*)sender
{
    if (self.buttonClick)
        self.buttonClick(sender);
}

@end
