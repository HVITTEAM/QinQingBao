//
//  GoodsDetailEndView.h
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTGoodsDetailEndViewDelegate;

@interface GoodsDetailEndView : UIView

@property(weak,nonatomic)id<MTGoodsDetailEndViewDelegate> delegate;

@property(nonatomic,strong)UILabel *Lab;
@property(nonatomic,strong)UILabel *Lab2;
@property(nonatomic,strong)UIButton *buyBt;
@property(nonatomic,strong)UIButton *add2Car;
@property(nonatomic,strong)UIButton *selectedAllbt;

@end

@protocol MTGoodsDetailEndViewDelegate <NSObject>

-(void)buyRightnowClick:(UIButton *)btn;

-(void)add2CarClick:(UIButton *)btn;

@end