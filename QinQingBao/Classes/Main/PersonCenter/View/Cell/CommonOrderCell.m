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

    //默认按钮都隐藏
    [self setPayBtnTitle:nil payBtnHide:YES delBtnTitle:nil delBtnHide:YES];
    
    if (status >= 0 && status <= 9) {
    
        if (payStatus == 0){
            str = @"未支付";
            [self setPayBtnTitle:@"去支付" payBtnHide:NO delBtnTitle:@"取消" delBtnHide:NO];
        }else if (payStatus == 1) {
            str = @"已支付";
            if (status == 8) {
                str = @"已分派";
            }
            if (!self.item.voucher_id) {
                [self setPayBtnTitle:nil payBtnHide:YES delBtnTitle:@"申请退款" delBtnHide:NO];
            }
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    
    }else if (status >= 10 && status <= 19){
        
        if (payStatus == 0){
            str = @"未支付";
            [self setPayBtnTitle:@"去支付" payBtnHide:NO delBtnTitle:@"取消" delBtnHide:NO];
        }else if (payStatus == 1) {
            str = @"已分派";
            if (status == 15) {
                str = @"服务开始";
            }
            if (!self.item.voucher_id) {
                [self setPayBtnTitle:nil payBtnHide:YES delBtnTitle:@"申请退款" delBtnHide:NO];
            }
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    
    }else if (status >= 20 && status <= 29){
        //无
    }else if (status >= 30 && status <= 49){
        if (payStatus == 0){
            str = @"未支付";
            [self setPayBtnTitle:@"去支付" payBtnHide:NO delBtnTitle:@"取消" delBtnHide:NO];
        }else if (payStatus == 1) {
            str = @"服务完成";
            if (status == 32) {
                str = @"服务完成";
                if (!self.item.voucher_id){
                   [self setPayBtnTitle:@"申请退款" payBtnHide:NO delBtnTitle:@"评价" delBtnHide:NO];
                }else{
                   [self setPayBtnTitle:nil payBtnHide:YES delBtnTitle:@"评价" delBtnHide:NO];
                }
            }
            
            if (status == 42 || [self.item.wgrade floatValue] != 0 || self.item.dis_con!=nil) {
                str = @"已评价";
            }
            
            if (status == 45) {
                str = @"服务完成";
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
        
    }else if (status >= 50 && status <= 59){
        str = @"已取消";
    }else if (status >= 60 && status <= 69){
        str = @"已拒单";
    }else if (status >= 70 && status <= 79){
        //无
    }else if (status >= 80 && status <= 99){
        str = @"完成";
    }else if (status >= 100 && status <= 119){
        str = @"投诉中";
    }else if (status >= 110 && status <= 129){
        str = @"退货中";
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

-(void)setPayBtnTitle:(NSString *)payTitle
           payBtnHide:(BOOL)isPayHide
          delBtnTitle:(NSString *)delTitle
           delBtnHide:(BOOL)isDelBtnHide
{
    self.payButton.hidden = isPayHide;
    [self.payButton setTitle:payTitle forState:UIControlStateNormal];
    
    self.deleteBtn.hidden = isDelBtnHide;
    [self.deleteBtn setTitle:delTitle forState:UIControlStateNormal];
}

@end
