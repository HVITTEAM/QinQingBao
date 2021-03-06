//
//  CommonGoodsCellHead.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsCellHead.h"


@implementation CommonGoodsCellHead

+(CommonGoodsCellHead *) commonGoodsCellHead
{
    CommonGoodsCellHead * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsCellHead" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
    CommonOrderModel *itemInfo = item.order_list[0];
    
    if ([itemInfo.order_state isEqualToString:@"0"])
        self.statusLab.text = @"已取消";
    else if ([itemInfo.order_state isEqualToString:@"10"])
        self.statusLab.text = @"未付款";
    else if ([itemInfo.order_state isEqualToString:@"20"])
        self.statusLab.text = @"已付款";
    else if ([itemInfo.order_state isEqualToString:@"30"])
        self.statusLab.text = @"已发货";
    else if ([itemInfo.order_state isEqualToString:@"40"])
        self.statusLab.text = @"交易完成";
}

-(void)setItemWithRefundData:(RefundListModel *)item
{
    switch ([item.refund_state integerValue]) {
        case 1:
            self.statusLab.text = @"已申请退款";
            break;
        case 2:
            self.statusLab.text = @"商家审核中";
            break;
        case 3:
            if ([item.seller_state integerValue] == 2) {
               self.statusLab.text = @"退款申请成功";
            }else if ([item.seller_state integerValue] == 3){
               self.statusLab.text = @"退款申请失败";
            }
            break;
        default:
             self.statusLab.text = @"已申请退款";
    }
}

-(void)initView
{
    self.height = 40;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
