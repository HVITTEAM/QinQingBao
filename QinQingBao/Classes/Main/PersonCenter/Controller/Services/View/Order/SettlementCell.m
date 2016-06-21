//
//  SettlementCell.m
//  QinQingBao
//
//  Created by shi on 16/3/22.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "SettlementCell.h"
#import "OrderModel.h"

@interface SettlementCell ()

@property (weak, nonatomic) IBOutlet UILabel *servicePriceLb;      //服务价格

@property (weak, nonatomic) IBOutlet UILabel *discountPriceLb;     //代金券价格

@property (weak, nonatomic) IBOutlet UILabel *lastPriceLb;         //结算价格

@property (weak, nonatomic) IBOutlet UILabel *payTypeLb;           //支付类型

@end

@implementation SettlementCell

+(instancetype)createSettlementCellWithTableView:(UITableView *)tableview
{
    static NSString *settlementCellId = @"settlementCell";
    SettlementCell *cell = [tableview dequeueReusableCellWithIdentifier:settlementCellId];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SettlementCell" owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataWithOrderModel:(OrderModel *)orderModel
{
    //设置代金券价格
    float voucherPrice = 0;
    self.discountPriceLb.text = @"无";
    if (orderModel.voucher_id && orderModel.voucher_price) {
        voucherPrice = [orderModel.voucher_price floatValue];
        self.discountPriceLb.text = [NSString stringWithFormat:@"-￥%.2f",voucherPrice];
    }
    
    //设置最终结算价格
    self.lastPriceLb.text = [NSString stringWithFormat:@"￥%@",orderModel.wprice];
    
    //设置原价
    if ([orderModel.wprice floatValue] <= 0) {
        self.servicePriceLb.text = @"面议";
    }else{
        self.servicePriceLb.text = [NSString stringWithFormat:@"￥%.2f",[orderModel.wprice floatValue] + voucherPrice];
    }
    
    //设置支付类型
    if ([orderModel.pay_staus integerValue] == 0) {
        self.payTypeLb.text = @"未支付";
    }else{
        NSString *payType;
        switch ([orderModel.pay_type integerValue]) {
            case 1:
                payType = @"支付宝";
                break;
            case 2:
                payType = @"微信";
                break;
            case 3:
                payType = @"现金";
                break;
            default:
                payType = @"未知方式";
                break;
        }
        self.payTypeLb.text = [NSString stringWithFormat:@"%@",payType];
    }
}

@end
