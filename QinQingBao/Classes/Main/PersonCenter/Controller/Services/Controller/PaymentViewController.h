//
//  PaymentViewController.h
//  QinQingBao
//
//  Created by shi on 16/5/5.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UITableViewController

@property(strong,nonatomic)NSString *imageUrlStr;              //订单图片，完整的图片url地址

@property(strong,nonatomic)NSString *content;                  //描述信息

@property(strong,nonatomic)NSString *wprice;                   //订单价格

@property(strong,nonatomic)NSString *wid;                      //订单id

@property(strong,nonatomic)NSString *wcode;                    //订单号

@property(strong,nonatomic)NSString *productName;              //产品名字   调用支付宝时需要传

@property(strong,nonatomic)NSString *store_id;                //店铺id

@property(weak,nonatomic)UIViewController *viewControllerOfback;

@end
