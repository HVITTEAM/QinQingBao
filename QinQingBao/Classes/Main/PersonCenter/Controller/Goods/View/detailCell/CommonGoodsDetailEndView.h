//
//  CommonGoodsDetailEndView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonOrderModel.h"
#import "CommonGoodsModel.h"

@interface CommonGoodsDetailEndView : UIView<UIAlertViewDelegate>
@property(nonatomic,strong)UIButton *buyBt;
@property(nonatomic,strong)UIButton *add2Car;

@property (nonatomic, retain) CommonOrderModel *goodsitemInfo;

@property (nonatomic, retain) CommonGoodsModel *goodsModel;

@property (nonatomic, retain) UINavigationController *nav;

@end
