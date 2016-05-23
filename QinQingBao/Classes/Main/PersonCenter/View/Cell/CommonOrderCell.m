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
    //    if ([priceStr isEqualToString:@"0"]|| [priceStr isEqualToString:@"0.00"]) {
    //        priceStr = @"面议";
    //    }
    self.servicePriceLab.text = priceStr;
    NSDate *tempDate = [self.formatterIn dateFromString:item.wtime];
    NSString *serviceTimeStr = [self.formatterOut stringFromDate:tempDate];
    self.serviceTimeLab.text = serviceTimeStr;
}

-(NSString *)getStatusByStatus:(int)status payStatus:(int)payStatus
{
    NSString *str;
    NSLog(@"paystatus---%d,status----%d",payStatus,status);
    if (payStatus == 0)//未付款
    {
        switch (status)
        {
            case 2:
            {
                str = @"提交订单";
                self.payButton.hidden = NO;
                self.deleteBtn.hidden = NO;
                [self.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
            }
                break;
            case 5:
            {
                str = @"提交订单";
                self.payButton.hidden = NO;
                self.deleteBtn.hidden = NO;
                [self.deleteBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [self.payButton setTitle:@"去支付" forState:UIControlStateNormal];
            }
                break;
            case 55:
            {
                str = @"已取消";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
            }
                break;
            default:
            {
                self.payButton.hidden = YES;
                self.deleteBtn.hidden = YES;
                str = @"";
            }
                break;
        }
    }
    else//已付款
    {
        self.payButton.hidden = YES;
        switch (status)
        {
            case 5:
            {
                str = @"提交订单";
                self.payButton.hidden = YES;
                self.deleteBtn.hidden = NO;
                [self.deleteBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }
                break;
            case 8:
            {
                str = @"已分派";
                self.payButton.hidden = NO;
                self.deleteBtn.hidden = NO;
                [self.payButton setTitle:@"申请退款" forState:UIControlStateNormal];
                [self.deleteBtn setTitle:@"评价" forState:UIControlStateNormal];
            }
                break;
            case 12:
            {
                str = @"";
                self.deleteBtn.hidden = NO;
                self.payButton.hidden = YES;
                [self.deleteBtn setTitle:@"评价" forState:UIControlStateNormal];
            }
                break;
            case 15:
            {
                str = @"服务开始";
                self.deleteBtn.hidden = NO;
                self.payButton.hidden = YES;
                [self.deleteBtn setTitle:@"评价" forState:UIControlStateNormal];
            }
                break;
            case 22:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
            }
                break;
            case 25:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
            }
                break;
            case 32:
            {
                str = @"服务结束";
                self.deleteBtn.hidden = NO;
                self.payButton.hidden = YES;
                [self.deleteBtn setTitle:@"评价" forState:UIControlStateNormal];
            }
                break;
            case 42:
            {
                if (self.item.wgrade)
                {
                    str = @"已评价";
                    self.deleteBtn.hidden = NO;
                    self.payButton.hidden = YES;
                    [self.deleteBtn setTitle:@"投诉" forState:UIControlStateNormal];
                }
                else
                {
                    str = @"";
                    self.deleteBtn.hidden = YES;
                    self.payButton.hidden = YES;
                }
            }
                break;
            case 45:
            {
                if (self.item.wgrade)
                {
                    str = @"已评价";
                    self.deleteBtn.hidden = NO;
                    self.payButton.hidden = YES;
                    [self.deleteBtn setTitle:@"投诉" forState:UIControlStateNormal];
                }
                else
                {
                    str = @"";
                    self.deleteBtn.hidden = YES;
                    self.payButton.hidden = YES;
                }
            }
                break;
            case 52:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
            }
                break;
            case 55:
            {
                str = @"已取消";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
            }
                break;
            case 62:
            {
                str = @"已拒单";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 82:
            {
                str = @"完成";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 85:
            {
                str = @"完成";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 102:
            {
                str = @"完成";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 109:
            {
                str = @"投诉中";
                self.deleteBtn.hidden = NO;
                self.payButton.hidden = YES;
                [self.deleteBtn setTitle:@"投诉" forState:UIControlStateNormal];
            }
                break;
            case 112:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 114:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 115:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 122:
            {
                str = @"退款中";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 125:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 128:
            {
                str = @"";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
                
            }
                break;
            case 132:
            {
                str = @"退款失败";
                self.deleteBtn.hidden = NO;
                self.payButton.hidden = YES;
                [self.deleteBtn setTitle:@"申请退款" forState:UIControlStateNormal];
            }
                break;
            case 135:
            {
                str = @"退款成功";
            }
                break;
            default:
            {
                str = @"未知状态";
                self.deleteBtn.hidden = YES;
                self.payButton.hidden = YES;
            }
                break;
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
