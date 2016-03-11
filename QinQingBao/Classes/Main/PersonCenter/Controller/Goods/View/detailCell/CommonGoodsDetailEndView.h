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

@class CommonGoodsDetailEndView;

@protocol CommonGoodsDetailEndViewDelegate <NSObject>

/**
 *  按钮点击后回调，index是点击的那个按钮的位置从左到右为第0个，第1个
 */
-(void)endView:(CommonGoodsDetailEndView *)endView button:(UIButton *)btn tappedAtIndex:(NSInteger)index;

@end

@interface CommonGoodsDetailEndView : UIView<UIAlertViewDelegate>
@property(nonatomic,strong)UIButton *buyBt;
@property(nonatomic,strong)UIButton *add2Car;

@property (nonatomic, retain) CommonGoodsModel *goodsitemInfo;

@property (nonatomic, retain) CommonGoodsModel *goodsModel;

@property (nonatomic, retain) UINavigationController *nav;

@property (nonatomic, weak) id<CommonGoodsDetailEndViewDelegate> delegate;

@end
