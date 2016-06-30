//
//  CommonOrderCell.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/24.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "CommonOrderCell.h"

@interface CommonOrderCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UILabel *statusLab;

@property (weak, nonatomic) IBOutlet UILabel *servicePriceLab;

@property (weak, nonatomic) IBOutlet UILabel *serviceManLab;

@property (weak, nonatomic) IBOutlet UILabel *companyLab;

//时间UILabel
@property (weak, nonatomic) IBOutlet UILabel *serviceTimeLab;

//时间标题UILabel
@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;

//底部四个按钮
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;

@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

@property (weak, nonatomic) IBOutlet UIButton *threeBtn;

@property (weak, nonatomic) IBOutlet UIButton *fourBtn;

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
        
    void (^setBtnBlock)(UIButton *btn) = ^(UIButton *btn){
        btn.layer.borderColor = HMColor(230, 230, 230).CGColor;
        btn.layer.cornerRadius = 6;
        btn.layer.borderWidth = 1;
    };
    
    setBtnBlock(self.oneBtn);
    setBtnBlock(self.twoBtn);
    setBtnBlock(self.threeBtn);
    setBtnBlock(self.fourBtn);
    
}

-(void)setItem:(OrderModel *)item
{
    _item = item;
    
    self.titleLab.text = item.icontent;
    self.statusLab.text = [self getStatusByStatus:[item.status intValue] payStatus:[item.pay_staus intValue]];
    self.serviceManLab.text = item.wname;
    self.companyLab.text = item.orgname;
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%@",item.wprice];
    //    if ([priceStr isEqualToString:@"0"]|| [priceStr isEqualToString:@"0.00"]) {
    //        priceStr = @"面议";
    //    }
    self.servicePriceLab.text = priceStr;
    NSDate *tempDate = [self.formatterIn dateFromString:item.wtime];
    NSString *serviceTimeStr = [self.formatterOut stringFromDate:tempDate];
    self.serviceTimeLab.text = serviceTimeStr;
    
    //tid 43为理疗服务  44为健康检测
    self.timeTitleLab.text = @"预约时间";
    if ([item.tid isEqualToString:@"44"]) {
        self.timeTitleLab.text = @"下单时间";
    }
}

-(NSString *)getStatusByStatus:(int)status payStatus:(int)payStatus
{
    NSString *str = nil;

    //默认按钮都隐藏
    self.oneBtn.hidden = YES;
    self.twoBtn.hidden = YES;
    self.threeBtn.hidden = YES;
    self.fourBtn.hidden = YES;
    
    if (status >= 0 && status <= 9) {
    
        if (payStatus == 0){
            str = @"未支付";
            [self showButtonWithTitle:@"取消"];
            [self showButtonWithTitle:@"去支付"];
        
        }else if (payStatus == 1) {
            str = @"已支付";
            
            if (status == 8) {
                str = @"已分派";
            }
            
            //超声理疗只要付了钱并分派了技师就可以评价,服务市场需要配送报告或上传报告后才能评价
            if (status >= 8) {
                //tid 43是超声理疗 44是服务市场
                if ([self.item.tid isEqualToString:@"43"]) {
                    if([self.item.wgrade floatValue] <= 0 && self.item.dis_con==nil){
                        [self showButtonWithTitle:@"评价"];
                    }
                }
            }
            
            if (!self.item.voucher_id) {
                //不是优惠券支付时才能退款
                [self showButtonWithTitle:@"申请退款"];
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
            [self showButtonWithTitle:@"取消"];
            [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            if (status == 15) {
                str = @"服务开始";
            }
            
            //超声理疗只要付了钱分并派了技师就可以评价,服务市场需要配送报告或上传报告后才能评价
            //tid 43是超声理疗 44是服务市场
            if ([self.item.tid isEqualToString:@"43"]) {
                if([self.item.wgrade floatValue] <= 0 && self.item.dis_con==nil){
                    [self showButtonWithTitle:@"评价"];
                }
            }
            
            if (!self.item.voucher_id) {
                //不是优惠券支付时才能退款
                [self showButtonWithTitle:@"申请退款"];
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    
    }else if (status >= 20 && status <= 29){
        if (payStatus == 0){
            str = @"未支付";
            [self showButtonWithTitle:@"取消"];
            [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            //只要器皿寄送出去了就不能退款
            //配送器皿相当于服务开始,配送报告或上传报告相当于服务结束（完成)
            
            if (status == 20) {
               //器皿配送
               [self showButtonWithTitle:@"查看物流"];
                if([self.item.wgrade floatValue] <= 0 && self.item.dis_con==nil){
                  [self showButtonWithTitle:@"评价"];
                }
                
            }else if (status == 21){
                str = @"已上传报告";
                [self showButtonWithTitle:@"查看物流"];
                [self showButtonWithTitle:@"查看医嘱"];
                if([self.item.wgrade floatValue] <= 0 && self.item.dis_con==nil){
                    [self showButtonWithTitle:@"评价"];
                }
                
            }else if(status == 22){
            //派送开始
                
            }else if (status == 23 ){
                str = @"已配送报告";
                [self showButtonWithTitle:@"查看物流"];
                [self showButtonWithTitle:@"查看医嘱"];
                if([self.item.wgrade floatValue] <= 0 && self.item.dis_con==nil){
                    [self showButtonWithTitle:@"评价"];
                }
            }else if (status == 25){
            //派送结束
                
            }
            
        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    }else if (status >= 30 && status <= 39){
        if (payStatus == 0){
            str = @"未支付";
            [self showButtonWithTitle:@"取消"];
            [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
        
            if (status == 32) {
                //超声理疗
                //评价了就不能退款
                str = @"服务完成";
                if([self.item.wgrade floatValue] <= 0 && self.item.dis_con==nil){
                    [self showButtonWithTitle:@"评价"];
                    if (!self.item.voucher_id){
                        [self showButtonWithTitle:@"申请退款"];
                    }
                }
            }

        }else if (payStatus == 2 || payStatus == 3) {
            str = @"退款中";
        }else if (payStatus == 4) {
            str = @"退款成功";
        }else if (payStatus == 5) {
            str = @"退款失败";
        }
    }else if (status >= 40 && status <= 49){
    
        if (payStatus == 0){
            str = @"未支付";
            [self showButtonWithTitle:@"取消"];
            [self showButtonWithTitle:@"去支付"];
        }else if (payStatus == 1) {
            
            if ([self.item.wgrade floatValue] > 0 || self.item.dis_con!=nil){
                str = @"已评价";
                //tid 43是超声理疗 44是服务市场
                if ([self.item.tid isEqualToString:@"44"]) {
                    [self showButtonWithTitle:@"查看物流"];
                    [self showButtonWithTitle:@"查看医嘱"];
                }
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
    }else if (status >= 100 && status <= 109){
        str = @"投诉中";
    }else if (status >= 110 && status <= 129){
        str = @"退货中";
    }
    
    return str;
}

- (IBAction)oneBtnClick:(id)sender
{
    self.deleteClick(sender);
}

- (IBAction)twoBtnClick:(id)sender
{
    self.deleteClick(sender);
}

- (IBAction)threeBtnClick:(id)sender
{
    self.deleteClick(sender);
}

- (IBAction)fourBtnClick:(id)sender
{
    self.deleteClick(sender);
}


/**
 *  显示一个操作按钮,从右侧开始显示
 *
 *  @param title 新显示按钮的标题
 */
-(void)showButtonWithTitle:(NSString *)title
{
    if (self.oneBtn.hidden) {
        [self.oneBtn setTitle:title forState:UIControlStateNormal];
        self.oneBtn.hidden = NO;
        return;
    }
    
    if (self.twoBtn.hidden) {
        [self.twoBtn setTitle:title forState:UIControlStateNormal];
        self.twoBtn.hidden = NO;
        return;
    }
    
    if (self.threeBtn.hidden) {
        [self.threeBtn setTitle:title forState:UIControlStateNormal];
        self.threeBtn.hidden = NO;
        return;
    }
    
    if (self.fourBtn.hidden) {
        [self.fourBtn setTitle:title forState:UIControlStateNormal];
        self.fourBtn.hidden = NO;
        return;
    }

}

@end
