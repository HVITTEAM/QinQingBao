//
//  RulerViewController.m
//  QinQingBao
//
//  Created by 董徐维 on 16/6/30.
//  Copyright © 2016年 董徐维. All rights reserved.
//

#import "RulerViewController.h"
#import "CXRuler.h"


@interface RulerViewController ()<CXRulerDelegate>

@end

@implementation RulerViewController
{
    UILabel *showLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initRuler];
}

-(instancetype)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

-(void)initRuler
{
    // 1.创建一个显示的标签
    showLabel = [[UILabel alloc] init];
    showLabel.font = [UIFont systemFontOfSize:20.f];
    showLabel.text = @"当前刻度值:20";
    showLabel.frame = CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 20 * 2, 40);
    showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:showLabel];
    
    CXRuler *ruler = [[CXRuler alloc] initWithFrame:CGRectMake(20, 220, self.view.width - 20 * 2, 120)];
    ruler.rulerDelegate = self;
    [ruler showRulerScrollViewWithCount:150 average:[NSNumber numberWithFloat:1] startValue:1900 currentValue:2016];
    [self.view addSubview:ruler];
}

- (void)CXRuler:(CXRulerScrollView *)rulerScrollView
{
    showLabel.text = [NSString stringWithFormat:@"当前刻度值: %.0f",rulerScrollView.rulerValue];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
