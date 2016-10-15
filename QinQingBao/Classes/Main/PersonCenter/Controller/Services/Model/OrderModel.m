//
//  OrderModel.m
//  QinQingBao
//
//  Created by 董徐维 on 15/11/25.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderModel.h"

NSString * const kStatusDesc = @"statusDesc";
NSString * const kButtonTitles = @"buttonTitles";

@implementation OrderModel


-(NSDictionary *)getOrderStatusAndButtonTitle
{
    NSString *str = nil;
    NSMutableArray *btnTitles = [[NSMutableArray alloc] init];
    
    int status = [self.status intValue];
    int payStatus = [self.pay_staus intValue];
    
    if (status >= 0 && status <= 9) {
        
        if (payStatus == 0){
            str = @"未支付";
            [btnTitles addObject:@"取消"];
            [btnTitles addObject:@"去支付"];
            
        }else if (payStatus == 1) {
            str = @"已支付";
            
            if (status == 8) {
                str = @"已分派";
            }
            
            //超声理疗只要付了钱并分派了技师就可以评价,服务市场需要配送报告或上传报告后才能评价
            if (status >= 8) {
                //tid 43是超声理疗 44是服务市场 47其他
                if ([self.tid isEqualToString:@"43"]) {
                    if([self.wgrade floatValue] <= 0 && self.dis_con==nil){
                        [btnTitles addObject:@"评价"];
                    }
                }
            }
            
            if (!self.voucher_id) {
                //不是优惠券支付时才能退款
                [btnTitles addObject:@"申请退款"];
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
            [btnTitles addObject:@"取消"];
            [btnTitles addObject:@"去支付"];
        }else if (payStatus == 1) {
            
            if (status == 15) {
                str = @"服务开始";
            }
            
            //超声理疗只要付了钱分并派了技师就可以评价,服务市场需要配送报告或上传报告后才能评价
            //tid 43是超声理疗 44是服务市场  47其他
            if ([self.tid isEqualToString:@"43"]) {
                if([self.wgrade floatValue] <= 0 && self.dis_con==nil){
                    [btnTitles addObject:@"评价"];
                }
            }
            
            if (!self.voucher_id) {
                //不是优惠券支付时才能退款
                [btnTitles addObject:@"申请退款"];
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
            [btnTitles addObject:@"取消"];
            [btnTitles addObject:@"去支付"];
        }else if (payStatus == 1) {
            
            //只要器皿寄送出去了就不能退款
            //配送器皿相当于服务开始,配送报告或上传报告相当于服务结束（完成)
            
            if (status == 20) {
                //器皿配送
                str = @"配送器皿";
                [btnTitles addObject:@"查看物流"];
                
            }else if (status == 21){
                str = @"已上传报告";
                [btnTitles addObject:@"查看物流"];
                [btnTitles addObject:@"检测报告"];
                [btnTitles addObject:@"干预方案"];
                if([self.wgrade floatValue] <= 0 && self.dis_con==nil){
                    [btnTitles addObject:@"评价"];
                }
                
            }else if(status == 22){
                //派送开始
                
            }else if (status == 23 ){
                str = @"已配送报告";
                [btnTitles addObject:@"查看物流"];
                [btnTitles addObject:@"检测报告"];
                [btnTitles addObject:@"干预方案"];
                if([self.wgrade floatValue] <= 0 && self.dis_con==nil){
                    [btnTitles addObject:@"评价"];
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
            [btnTitles addObject:@"取消"];
            [btnTitles addObject:@"去支付"];
        }else if (payStatus == 1) {
            
            if (status == 32) {
                //超声理疗
                //评价了就不能退款
                str = @"服务完成";
                if([self.wgrade floatValue] <= 0 && self.dis_con==nil){
                    [btnTitles addObject:@"评价"];
                    if (!self.voucher_id){
                        [btnTitles addObject:@"申请退款"];
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
            [btnTitles addObject:@"取消"];
            [btnTitles addObject:@"去支付"];
        }else if (payStatus == 1) {
            
            if ([self.wgrade floatValue] > 0 || self.dis_con!=nil){
                str = @"已评价";
                //tid 43是超声理疗 44是服务市场 47其他
                if (![self.tid isEqualToString:@"43"]) {
                    [btnTitles addObject:@"查看物流"];
                    [btnTitles addObject:@"检测报告"];
                    [btnTitles addObject:@"干预方案"];
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
    
    //设置返回数据
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:str forKey:kStatusDesc];
    
    if (btnTitles.count > 0) {
        [dict setValue:btnTitles forKey:kButtonTitles];
    }
    
    return dict;
}


@end
