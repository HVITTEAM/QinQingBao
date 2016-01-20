//
//  GoodsSelectedViewController.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/10.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsSelectedViewController : UIViewController

@property (nonatomic, assign) OrderType *type;

//添加购物车提交bloce
@property (nonatomic, copy) void (^submitClick)(BOOL isSuccess);

@property (nonatomic, copy) void (^orderClick)(NSString *number);

@property (nonatomic,strong) NSString *goodsID;

@property (nonatomic, strong) UIViewController *parentVC;
@end
