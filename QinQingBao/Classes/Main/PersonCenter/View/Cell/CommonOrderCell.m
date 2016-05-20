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
    if (payStatus == 0)
    {
        str = @"待付款";
        [self.deleteBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    else if (status >= 0 && status <= 9)
    {
        str = @"待服务";
        [self.deleteBtn setTitle:@"申请退款" forState:UIControlStateNormal];
    }
    else if (status >= 30 && status <= 39)
    {
        str = @"待评价";
        [self.deleteBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    else if (status >= 50 && status <= 69)
    {
        str = @"取消/售后";
        [self.deleteBtn setTitle:@"去结算" forState:UIControlStateNormal];
    }
    else if (status >= 120 && status <= 129)
    {
        str = @"退款中";
    }
    else if (status >= 130 && status <= 139)
    {
        if (status == 132)
            str = @"退款失败";
        if (status == 132)
            str = @"退款成功";
    }
    return str;
}
- (IBAction)deleteBtnClickHandler:(id)sender
{
    self.deleteClick(sender);
}
@end
