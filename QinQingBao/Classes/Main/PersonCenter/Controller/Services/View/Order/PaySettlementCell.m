//
//  PaySettlementCell.m
//  QinQingBao
//
//  Created by shi on 16/3/25.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "PaySettlementCell.h"

@interface PaySettlementCell ()

@property (weak, nonatomic) IBOutlet UILabel *servicePriceLb;        //服务价格

@property (weak, nonatomic) IBOutlet UIButton *couponBtn;            //代金券

@property (weak, nonatomic) IBOutlet UILabel *lastPriceLb;           //结算价格

@property (strong,nonatomic)OrderModel *orderInfo;

@end

@implementation PaySettlementCell

+(instancetype)createPaySettlementCellWithTableView:(UITableView *)tableview
{
   static NSString *paySettlementCellId = @"paySettlementCell";
    PaySettlementCell *cell = [tableview dequeueReusableCellWithIdentifier:paySettlementCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PaySettlementCell" owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)useCouponAction:(id)sender
{
    //如果已经已有优惠卷，由于无法再次锁定，所以不需要再让用户去选择代金券
    if (self.orderInfo.voucher_price && self.orderInfo.voucher_id) {
        return;
    }
    
    if (self.couponHandle) {
        self.couponHandle();
    }
}

-(void)setDataWithOrderModel:(OrderModel *)orderModel couponsModel:(CouponsModel *)aCouponModel
{
    self.orderInfo = orderModel;
    
    CGFloat couponPrice = 0;
    [self.couponBtn setTitle:@"立即使用" forState:UIControlStateNormal];
    
    //已经已有优惠卷
    if (orderModel.voucher_price && orderModel.voucher_id) {
        couponPrice = [orderModel.voucher_price floatValue];
        [self.couponBtn setTitle:[NSString stringWithFormat:@"￥%.2f",couponPrice] forState:UIControlStateNormal];
        
        self.lastPriceLb.text = orderModel.wprice;
        
        self.servicePriceLb.text = [NSString stringWithFormat:@"￥%.2f",[orderModel.wprice floatValue] + couponPrice];
        
        return;
    }
    
    if (aCouponModel) {
        if ([orderModel.wprice floatValue] >= [aCouponModel.voucher_limit floatValue]) {
            couponPrice = [aCouponModel.voucher_price floatValue];
            [self.couponBtn setTitle:[NSString stringWithFormat:@"-￥%.2f",couponPrice] forState:UIControlStateNormal];
        }
    }
    
    self.servicePriceLb.text = [NSString stringWithFormat:@"￥%@",orderModel.wprice];
    self.lastPriceLb.text = [NSString stringWithFormat:@"￥%.2f",[orderModel.wprice floatValue] - couponPrice];
}

@end
