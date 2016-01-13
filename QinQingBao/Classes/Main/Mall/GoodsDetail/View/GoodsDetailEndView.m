//
//  GoodsDetailEndView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/1/8.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "GoodsDetailEndView.h"
//按钮宽度
static CGFloat BUTTON_WIDTH;
//客服宽度
static CGFloat CHAT_WIDTH;



@interface GoodsDetailEndView ()

@end

@implementation GoodsDetailEndView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        BUTTON_WIDTH = MTScreenW *0.3;
        CHAT_WIDTH = MTScreenW *0.2;
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
    
    UIImageView *chatImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chatshop.png"]];
    chatImg.frame = CGRectMake(CHAT_WIDTH/2 - 10, 5, 20, 20);
    [self addSubview:chatImg];
    
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(0, 25,CHAT_WIDTH, 23)];
    _Lab.textAlignment = NSTextAlignmentCenter;
    _Lab.textColor=[UIColor colorWithRGB:@"666666"];
    _Lab.text=[NSString stringWithFormat:@"客服"];
    _Lab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_Lab];
    
    UIImageView *line1 = [[UIImageView alloc]initWithFrame:CGRectMake(CHAT_WIDTH, 0, 0.5, self.height)];
    line1.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line1];
    
    _Lab2 =[[UILabel alloc]initWithFrame:CGRectMake(CHAT_WIDTH, 25,CHAT_WIDTH, 23)];
    _Lab2.textAlignment = NSTextAlignmentCenter;
    _Lab2.textColor=[UIColor colorWithRGB:@"666666"];
    _Lab2.text=[NSString stringWithFormat:@"收藏"];
    _Lab2.font=[UIFont systemFontOfSize:12];
    [self addSubview:_Lab2];
    
    UIImageView *chatImg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"collectshop"]];
    chatImg1.frame = CGRectMake(CHAT_WIDTH + CHAT_WIDTH /2- 10, 5, 20, 20);
    [self addSubview:chatImg1];
    
    //立刻购买
    _buyBt = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - BUTTON_WIDTH, 0, BUTTON_WIDTH, self.height)];
    _buyBt.hidden = NO;
    _buyBt.tag=18;
    [_buyBt setTitle:@"立即购买" forState:UIControlStateNormal];
    [_buyBt.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [[_buyBt layer]setCornerRadius:3.0];
    [_buyBt addTarget:self action:@selector(buyRightnowClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_buyBt];
    
    //加入购物车
    _add2Car = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - 2*BUTTON_WIDTH, 0, BUTTON_WIDTH, self.height)];
    _add2Car.hidden = NO;
    _add2Car.tag=18;
    [_add2Car setTitle:@"加入购物车" forState:UIControlStateNormal];
    [_add2Car.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    
    [_add2Car setBackgroundImage:[UIImage imageWithColor:MTNavgationBackgroundColor] forState:UIControlStateNormal];
    [_add2Car setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [[_add2Car layer]setCornerRadius:3.0];
    [_add2Car addTarget:self action:@selector(add2CarClick:) forControlEvents:UIControlEventTouchUpInside];
    [_add2Car setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_add2Car];

}

-(void)buyRightnowClick:(UIButton *)btn
{
    [self.delegate buyRightnowClick:btn];
}

-(void)add2CarClick:(UIButton *)btn
{
    [self.delegate add2CarClick:btn];
}

@end
