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
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MTScreenW, 0.5)];
    line.backgroundColor=[UIColor colorWithRGB:@"e2e2e2"];
    [self addSubview:line];
    
    //提交订单
    _buyBt = [[UIButton alloc]initWithFrame:CGRectMake(MTScreenW - BUTTON_WIDTH, 0, BUTTON_WIDTH, self.height)];
    _buyBt.hidden = NO;
    _buyBt.tag=18;
    [_buyBt setTitle:@"提交订单" forState:UIControlStateNormal];
    [_buyBt.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
    [_buyBt setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    
    [[_buyBt layer]setCornerRadius:3.0];
    [_buyBt addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    [_buyBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_buyBt];
    
    _Lab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_buyBt.frame) - CHAT_WIDTH, 3,CHAT_WIDTH, 25)];
    _Lab.textAlignment = NSTextAlignmentCenter;
    _Lab.textColor=[UIColor colorWithRGB:@"333333"];
    //    _Lab.text=[NSString stringWithFormat:@"共3件,总金额￥647.00"];
    
    NSString *string                            = @"共3件,总金额￥647.00";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRGB:@"dd2726"]
                             range:NSMakeRange(1, 1)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRGB:@"dd2726"]
                             range:NSMakeRange(string.length - 7, 7)];
    
    _Lab.attributedText = attributedString;
    
    _Lab.font=[UIFont systemFontOfSize:14];
    [self addSubview:_Lab];
    
    _freightLab =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_buyBt.frame) - CHAT_WIDTH, 23, 150, 25)];
    _freightLab.textColor=[UIColor colorWithRGB:@"666666"];
    _freightLab.text=[NSString stringWithFormat:@"不含运费"];
    _freightLab.font=[UIFont systemFontOfSize:12];
    _freightLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_freightLab];

}

-(void)setGoodsCount:(NSString *)count totalPrice:(NSString *)totalPrice
{
    NSString *string = [NSString stringWithFormat:@"共%@件,总金额%@",count,totalPrice];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];

    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRGB:@"dd2726"]
                             range:NSMakeRange(1, count.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor colorWithRGB:@"dd2726"]
                             range:NSMakeRange(count.length + 6 , totalPrice.length)];
    
    _Lab.attributedText = attributedString;

}

-(void)submitClick:(UIButton *)btn
{
    [self.delegate submitClick:btn];
}

@end
