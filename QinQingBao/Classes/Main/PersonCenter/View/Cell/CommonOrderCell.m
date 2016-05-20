//
//  CommonOrderCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonOrderCell.h"

@interface CommonOrderCell ()

@property (strong, nonatomic) IBOutlet UIView *topSapce;

@property (strong, nonatomic) IBOutlet UIView *bottomSpace;

@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;

@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UILabel *servicePriceLab;

@property (weak, nonatomic) IBOutlet UILabel *serviceManLab;

@property (weak, nonatomic) IBOutlet UILabel *companyLab;

@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;

@end

@implementation CommonOrderCell


+(CommonOrderCell *) commonOrderCell
{
    CommonOrderCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CommonOrderCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.topSapce.backgroundColor = HMColor(234, 234, 234);
    self.bottomSpace.backgroundColor = HMColor(234, 234, 234);
    
    self.deleteBtn.layer.borderColor = HMColor(200, 200, 200).CGColor;
    self.deleteBtn.layer.cornerRadius = 8;
    self.deleteBtn.layer.borderWidth = 1;
    
    self.payButton.layer.borderColor = HMColor(200, 200, 200).CGColor;
    self.payButton.layer.cornerRadius = 8;
    self.payButton.layer.borderWidth = 1;
}

-(void)setItem:(OrderModel *)item
{
    _item = item;
    
    self.titleLab.text = item.icontent;
    self.statusLab.text = [self getStatusByStatus:[item.status intValue] payStatus:[item.pay_staus intValue]];
    self.serviceManLab.text = item.wname;
    self.companyLab.text = item.orgname;
    
    NSString *priceStr = item.wprice;
    if ([priceStr isEqualToString:@"0"]|| [priceStr isEqualToString:@"0.00"]) {
        priceStr = @"面议";
    }
    self.servicePriceLab.text = priceStr;
    NSDate *tempDate = [self.formatterIn dateFromString:item.wtime];
    NSString *serviceTimeStr = [self.formatterOut stringFromDate:tempDate];
    self.serviceTimeLab.text = serviceTimeStr;
    
}

-(NSString *)getStatusByStatus:(int)status payStatus:(int)payStatus
{
    NSString *str;
    if (payStatus == 0 && (status >= 7 && status <= 50))
    {
        str = @"待付款";
        self.payButton.hidden = NO;
        self.deleteBtn.hidden = NO;
        [self.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
    }
    else
    {
        self.payButton.hidden = YES;
        if (status >= 0 && status <= 9)
        {
            str = @"等待接单";
            self.payButton.hidden = NO;
            [self.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        }
        else if (status >= 10 && status <= 19)
        {
            str = @"已接单";
            self.payButton.hidden = NO;
            [self.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"联系商家" forState:UIControlStateNormal];
        }
        else if (status >= 30 && status <= 39)
        {
            str = @"服务结束";
            self.payButton.hidden = NO;
            [self.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"评价" forState:UIControlStateNormal];
        }
        else if ((status >= 40 && status <= 49 ) && self.item.wgrade)
        {
            str = @"已评价";
            self.payButton.hidden = NO;
            [self.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
            [self.deleteBtn setTitle:@"投诉" forState:UIControlStateNormal];
        }
        else if (status >= 50 && status <= 59)
        {
            str = @"已取消";
            self.deleteBtn.hidden = YES;
        }
        else if (status >= 60 && status <= 69)
        {
            str = @"已拒单";
            self.deleteBtn.hidden = YES;
        }
        else if (status >= 80 && status <= 99)
        {
            str = @"完成";
            self.deleteBtn.hidden = YES;
        }
        else if (status >= 100 && status <= 109)
        {
            str = @"投诉中";
            if (status == 109)
                [self.deleteBtn setTitle:@"投诉" forState:UIControlStateNormal];
            else
                self.deleteBtn.hidden = YES;
        }
        else if (status >= 120 && status <= 129)
        {
            str = @"退款中";
            self.deleteBtn.hidden = YES;
        }
        else if (status >= 130 && status <= 139)
        {
            if (status == 132)
                str = @"退款失败";
            if (status == 135)
                str = @"退款成功";
            self.deleteBtn.hidden = YES;
        }
        else
        {
            [self.deleteBtn setTitle:@"未知状态" forState:UIControlStateNormal];
            str = @"未知状态";
        }
    }
    return str;
}
- (IBAction)deleteBtnClickHandler:(id)sender
{
    self.deleteClick(sender);
}
- (IBAction)payClick:(id)sender
{
    self.deleteClick(sender);
}
@end
