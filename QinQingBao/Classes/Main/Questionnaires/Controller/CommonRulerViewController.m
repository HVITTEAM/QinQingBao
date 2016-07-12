//
//  RulerViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "CommonRulerViewController.h"
#import "CXRuler.h"


@interface CommonRulerViewController ()<CXRulerDelegate>
{
    
}
@end

@implementation CommonRulerViewController
{
    UILabel *showLabel;
    CGFloat _startValue;
    CGFloat _currentValue;
    NSString *_unit;
    NSUInteger _count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRuler];
    [self initButton];
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)initWithTitle:(NSString *)title startValue:(CGFloat)startValue currentValue:(CGFloat)currentValue count:(NSUInteger)count unit:(NSString *)unit
{
    self.title = title;
    _startValue = startValue;
    _currentValue = currentValue;
    _count = count;
    _unit = unit;
}

-(void)initRuler
{
    UIImageView *headimg = [[UIImageView alloc] initWithFrame:CGRectMake(MTScreenW/2 - 50, 90, 100, 100)];
    headimg.image = [UIImage imageNamed:@"1.png"];
    [self.view addSubview:headimg];
    
    UILabel  *titleLab= [[UILabel alloc] init];
    titleLab.font = [UIFont systemFontOfSize:16.f];
    titleLab.frame = CGRectMake(MTScreenW/2 - 100, 190, 200, 40);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = [NSString stringWithFormat:@"您的%@",self.title];
    titleLab.textColor = [UIColor darkGrayColor];
    [self.view addSubview:titleLab];

    
    // 1.创建一个显示的标签
    showLabel = [[UILabel alloc] init];
    showLabel.font = [UIFont systemFontOfSize:20.f];
    showLabel.frame = CGRectMake(MTScreenW/2 - 100, 270, 200, 40);
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showLabel];
    
    CXRuler *ruler = [[CXRuler alloc] initWithFrame:CGRectMake(30, 300, MTScreenW - 60, 120)];
    ruler.rulerDelegate = self;
    [ruler showRulerScrollViewWithCount:_count average:[NSNumber numberWithFloat:1] startValue:_startValue currentValue:_currentValue];
    [self.view addSubview:ruler];
}

- (void)CXRuler:(CXRulerScrollView *)rulerScrollView
{
    NSString *value                             = [NSString stringWithFormat:@"%.0f",rulerScrollView.rulerValue];
    NSString *string                            = [NSString stringWithFormat:@"%@%@",value,_unit];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    // 设置富文本样式
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor orangeColor]
                             range:NSMakeRange(0, value.length)];
    
    [attributedString addAttribute:NSFontAttributeName
                             value:[UIFont systemFontOfSize:13.f]
                             range:NSMakeRange(value.length, _unit.length)];
    
    showLabel.attributedText = attributedString;
}

-(void)initButton
{
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, MTScreenH - 59.5, MTScreenW, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, MTScreenH - 60, MTScreenW, 60)];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
//    [nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor]] forState:UIControlStateNormal];
//    [nextBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [nextBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTitleColor:HMColor(139, 198, 63) forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
}

-(void)sure:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
