//
//  HeadProcessView.m
//  QinQingBao
//
//  Created by 董徐维 on 16/2/17.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "HeadProcessView.h"

@implementation HeadProcessView

- (void)drawRect:(CGRect)rect
{
    
}

-(void)initWithShowIndex:(NSInteger)idx
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 15, MTScreenW - 20, 0.7)];
    line.backgroundColor = [UIColor colorWithRGB:@"d9d9d9"];
    [self addSubview:line];
    
    UIView *circle0 = [[UIView alloc] initWithFrame:CGRectMake(MTScreenW/5 - 5, 10, 10, 10)];
    circle0.backgroundColor = MTNavgationBackgroundColor;
    circle0.layer.cornerRadius = 5;
    [self addSubview:circle0];
    
    UILabel *lab0 = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/5 - 40, 23, 80, 20)];
    lab0.text = @"基本信息";
    lab0.textAlignment = NSTextAlignmentCenter;
    lab0.font = [UIFont systemFontOfSize:13];
    lab0.textColor = [UIColor colorWithRGB:@"666666"];
    [self addSubview:lab0];
    
    UIView *circle1 = [[UIView alloc] initWithFrame:CGRectMake(MTScreenW/5*2 - 5, 10, 10, 10)];
    circle1.backgroundColor = MTNavgationBackgroundColor;
    circle1.layer.cornerRadius = 5;
    [self addSubview:circle1];
    
    UILabel *lab1 = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/5*2 - 40, 23, 80, 20)];
    lab1.text = @"疾病史";
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:13];
    lab1.textColor = [UIColor colorWithRGB:@"666666"];
    [self addSubview:lab1];
    
    UIView *circle2 = [[UIView alloc] initWithFrame:CGRectMake(MTScreenW/5*3 - 5, 10, 10, 10)];
    circle2.backgroundColor = MTNavgationBackgroundColor;
    circle2.layer.cornerRadius = 5;
    [self addSubview:circle2];
    
    UILabel *lab2 = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/5*3 - 40, 23, 80, 20)];
    lab2.text = @"生活习惯";
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.font = [UIFont systemFontOfSize:13];
    lab2.textColor = [UIColor colorWithRGB:@"666666"];
    [self addSubview:lab2];
    
    UIView *circle3 = [[UIView alloc] initWithFrame:CGRectMake(MTScreenW/5*4 - 5, 10, 10, 10)];
    circle3.backgroundColor = MTNavgationBackgroundColor;
    circle3.layer.cornerRadius = 5;
    [self addSubview:circle3];
    
    UILabel *lab3 = [[UILabel alloc] initWithFrame:CGRectMake(MTScreenW/5*4 - 40, 23, 80, 20)];
    lab3.text = @"医诊报告";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = [UIFont systemFontOfSize:13];
    lab3.textColor = [UIColor colorWithRGB:@"666666"];
    [self addSubview:lab3];
    
    switch (idx) {
        case 0:
        {
            circle0.backgroundColor = MTNavgationBackgroundColor;
            lab0.textColor = [UIColor colorWithRGB:@"666666"];
            circle1.backgroundColor = [UIColor lightGrayColor];
            lab1.textColor = [UIColor lightGrayColor];
            circle2.backgroundColor = [UIColor lightGrayColor];
            lab2.textColor = [UIColor lightGrayColor];
            circle3.backgroundColor = [UIColor lightGrayColor];
            lab3.textColor = [UIColor lightGrayColor];
        }
            break;
        case 1:
        {
            circle1.backgroundColor = MTNavgationBackgroundColor;
            lab1.textColor = [UIColor colorWithRGB:@"666666"];
            circle0.backgroundColor = [UIColor lightGrayColor];
            lab0.textColor = [UIColor lightGrayColor];
            circle2.backgroundColor = [UIColor lightGrayColor];
            lab2.textColor = [UIColor lightGrayColor];
            circle3.backgroundColor = [UIColor lightGrayColor];
            lab3.textColor = [UIColor lightGrayColor];
        }
            break;
        case 2:
        {
            circle2.backgroundColor = MTNavgationBackgroundColor;
            lab2.textColor = [UIColor colorWithRGB:@"666666"];
            circle1.backgroundColor = [UIColor lightGrayColor];
            lab1.textColor = [UIColor lightGrayColor];
            circle0.backgroundColor = [UIColor lightGrayColor];
            lab0.textColor = [UIColor lightGrayColor];
            circle3.backgroundColor = [UIColor lightGrayColor];
            lab3.textColor = [UIColor lightGrayColor];
        }
            break;
        case 3:
        {
            circle3.backgroundColor = MTNavgationBackgroundColor;
            lab3.textColor = [UIColor colorWithRGB:@"666666"];
            circle1.backgroundColor = [UIColor lightGrayColor];
            lab1.textColor = [UIColor lightGrayColor];
            circle0.backgroundColor = [UIColor lightGrayColor];
            lab0.textColor = [UIColor lightGrayColor];
            circle2.backgroundColor = [UIColor lightGrayColor];
            lab2.textColor = [UIColor lightGrayColor];
        }
            break;
        default:
            break;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, MTScreenW, 35)];
    bottomView.backgroundColor = HMColor(231, 225, 217);
    [self addSubview:bottomView];
    
    UILabel *lab5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, MTScreenW, 20)];
    lab5.text = @"此信息将作为健康管理师给您制定方案的依据,请如实填写";
    lab5.textAlignment = NSTextAlignmentCenter;
    lab5.font = [UIFont systemFontOfSize:12];
    lab5.textColor = [UIColor colorWithRGB:@"c69666"];
    [bottomView addSubview:lab5];
    
}
@end
