//
//  GoodsDetailEndView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "ConfirmOrderEndView.h"
//按钮宽度
static CGFloat BUTTON_WIDTH;
//客服宽度
static CGFloat CHAT_WIDTH;


@interface ConfirmOrderEndView ()

@end

@implementation ConfirmOrderEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        BUTTON_WIDTH = MTScreenW *0.3;
        CHAT_WIDTH = MTScreenW *0.5;
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}


-(void)initView
{
      //提交订单
    _buyBt = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - BUTTON_WIDTH, 0, BUTTON_WIDTH, self.height)];
    _buyBt.hidden = NO;
    _buyBt.tag=18;
    [_buyBt setTitle:@"提交订单" forState:UIControlStateNormal];
    [_buyBt.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [[_buyBt layer]setCornerRadius:3.0];
    [_buyBt addTarget:self action:@selector(buyRightnowClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_buyBt];
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_buyBt.frame) - CHAT_WIDTH, 0,CHAT_WIDTH, self.height)];
    _Lab.textAlignment = NSTextAlignmentCenter;
    _Lab.textColor=[UIColor colorWithRGB:@"333333"];
    _Lab.text=[NSString stringWithFormat:@"共三件,总金额为￥647.00"];
    _Lab.font=[UIFont systemFontOfSize:14];
    [self addSubview:_Lab];
    
}

-(void)buyRightnowClick:(UIButton *)btn
{
    [self.delegate buyRightnowClick:btn];
}

@end
