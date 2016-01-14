//
//  CommonGoodsCellBottom.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonGoodsCellBottom.h"
#import "CommonGoodsModel.h"
#import "ExtendOrderGoodsModel.h"
@implementation CommonGoodsCellBottom
{
    CommonOrderModel *goodsitemInfo;
}


+(CommonGoodsCellBottom *) commonGoodsCellBottom
{
    CommonGoodsCellBottom * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonGoodsCellBottom" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initView];
    return cell;
}

-(void)setitemWithData:(CommonGoodsModel *)item
{
    CommonOrderModel *itemInfo = item.order_list[0];
    
    goodsitemInfo = itemInfo;
    //一个订单有多少个商品
    NSString *goodsCount = [NSString stringWithFormat:@"%lu",(unsigned long)itemInfo.extend_order_goods.count];
    //总金额
    NSString *totalPrice = itemInfo.order_amount;
    //运费
    NSString *shipping_fee = itemInfo.shipping_fee;
    
    NSString *string                            = [NSString stringWithFormat:@"共%@件商品,合计￥%@ （含运费￥%@）",goodsCount,totalPrice,shipping_fee];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor redColor]
                             range:NSMakeRange(1, goodsCount.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:11.f]
                             range:NSMakeRange(7 + goodsCount.length, 1)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:15.f]
                             range:NSMakeRange(8 + goodsCount.length, totalPrice.length)];
    
    self.desLab.attributedText = attributedString;
    
    [self setButtonTitles];
}

-(void)initView
{
    self.height = 75;
    
    self.bottomLine.backgroundColor = [UIColor colorWithRGB:@"e2e2e2"];
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.height, MTScreenW, 0.5)];
    line1.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line1];
    
    _evaBtn.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _evaBtn.layer.borderWidth = 0.5f;
    _evaBtn.layer.cornerRadius = 4;
    [_evaBtn setTitleColor:[UIColor colorWithRGB:@"f14950"] forState:UIControlStateNormal];
    _evaBtn.layer.borderColor = [[UIColor colorWithRGB:@"f14950"] CGColor];
    [_evaBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_evaBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_evaBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_evaBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _deliverBtn.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _deliverBtn.layer.borderWidth = 0.5f;
    _deliverBtn.layer.cornerRadius = 4;
    [_deliverBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_deliverBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_deliverBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_deliverBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deliverBtn setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];
    
    _delateBtn.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _delateBtn.layer.borderWidth = 0.5f;
    _delateBtn.layer.cornerRadius = 4;
    [_delateBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_delateBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_delateBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    [_delateBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_delateBtn setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];
    
}

-(void)setButtonTitles
{
    if ([goodsitemInfo.order_state isEqualToString:@"0"])//已取消
    {
        [_evaBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        _delateBtn.hidden = YES;
        _deliverBtn.hidden = YES;
    }
    else if ([goodsitemInfo.order_state isEqualToString:@"10"])//未付款
    {
        _delateBtn.hidden = YES;
        [_evaBtn setTitle:@"支付" forState:UIControlStateNormal];
        [_deliverBtn setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    else if ([goodsitemInfo.order_state isEqualToString:@"20"])//已付款
    {
        [_evaBtn setTitle:@"提醒发货" forState:UIControlStateNormal];
        _delateBtn.hidden = YES;
        _deliverBtn.hidden = YES;
    }
    else if ([goodsitemInfo.order_state isEqualToString:@"30"])//已发货
    {
        _delateBtn.hidden = YES;
        [_evaBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_deliverBtn setTitle:@"查看物流" forState:UIControlStateNormal];
    }
    else if ([goodsitemInfo.order_state isEqualToString:@"40"])//交易完成
    {
        [_delateBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_evaBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_deliverBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
}

-(void)buttonClick:(UIButton*)sender
{
    if (self.buttonClick)
        self.buttonClick(sender);
}

@end
