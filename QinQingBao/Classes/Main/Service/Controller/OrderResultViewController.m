//
//  OrderResultViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 15/12/23.
//  Copyright © 2015年 董徐维. All rights reserved.
//

#import "OrderResultViewController.h"

@interface OrderResultViewController ()

@end

@implementation OrderResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"提交结果";
    self.backBtn.layer.cornerRadius = 4;
    
    self.orderNum.text = [NSString stringWithFormat:@"订单编号: %@",self.orderItem.wcode];
    self.orderPrice.text = [NSString stringWithFormat:@"订单金额: %@ 元",self.orderItem.wprice];
    
}

-(void)setOrderItem:(OrderItem *)orderItem
{
    _orderItem = orderItem;
}

- (IBAction)backHandler:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
