//
//  GoodsDetailEndView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTConfirmOrderEndViewDelegate;

@interface ConfirmOrderEndView : UIView

@property(weak,nonatomic)id<MTConfirmOrderEndViewDelegate>delegate;
@property(nonatomic,strong)UILabel *freightLab;

@property(nonatomic,strong)UILabel *Lab;
@property(nonatomic,strong)UILabel *Lab2;
@property(nonatomic,strong)UIButton *buyBt;
@property(nonatomic,strong)UIButton *add2Car;
@property(nonatomic,strong)UIButton *selectedAllbt;

/**
 * 设置总数和总价
 **/
-(void)setGoodsCount:(NSString *)count totalPrice:(NSString *)totalPrice;

@end

@protocol MTConfirmOrderEndViewDelegate<NSObject>

-(void)submitClick:(UIButton *)btn;

@end