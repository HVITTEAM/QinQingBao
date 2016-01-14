//
//  CommonGoodsDetailEndView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/14.
//  Copyright © 2016年 董徐维. All rights reserved.
//
//按钮宽度
static CGFloat BUTTON_WIDTH = 80;

#import "CommonGoodsDetailEndView.h"

@implementation CommonGoodsDetailEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}


-(void)initView
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    
    //立刻购买
    _buyBt = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - BUTTON_WIDTH - 10, 10, BUTTON_WIDTH, self.height - 20)];
    _buyBt.hidden = NO;
    [_buyBt setTitle:@"评价" forState:UIControlStateNormal];
    _buyBt.layer.borderColor = [[UIColor colorWithRGB:@"f14950"] CGColor];
    _buyBt.layer.borderWidth = 0.5f;
    _buyBt.layer.cornerRadius = 4;
    [_buyBt.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    
    [_buyBt addTarget:self action:@selector(buyRightnowClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBt setTitleColor:[UIColor colorWithRGB:@"f14950"] forState:UIControlStateNormal];
    [self addSubview:_buyBt];
    
    //加入购物车
    _add2Car = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 2*BUTTON_WIDTH - 20, 10, BUTTON_WIDTH, self.height -20)];
    _add2Car.hidden = NO;
    [_add2Car setTitle:@"取消订单" forState:UIControlStateNormal];
    _add2Car.layer.borderColor = [[UIColor colorWithRGB:@"666666"] CGColor];
    _add2Car.layer.borderWidth = 0.5f;
    _add2Car.layer.cornerRadius = 4;
    [_add2Car.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [_add2Car setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [_add2Car setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    
    [_add2Car addTarget:self action:@selector(add2CarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_add2Car setTitleColor:[UIColor colorWithRGB:@"666666"] forState:UIControlStateNormal];
    [self addSubview:_add2Car];
    
}

-(void)buyRightnowClick:(UIButton *)btn
{
}

-(void)add2CarClick:(UIButton *)btn
{
}
@end
