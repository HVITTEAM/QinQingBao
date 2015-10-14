//
//  OrderFormDetailController.m
//  QinQinBao
//
//  Created by 董徐维 on 15/6/25.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "OrderFormDetailController.h"
#import "TimeLineViewControl.h"

@interface OrderFormDetailController ()

@end

@implementation OrderFormDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initNavigation];
    
    [self initView];
}

/**
 *  初始化导航栏
 */
-(void)initNavigation
{
    self.title = @"订单详情";
    self.view.backgroundColor = HMGlobalBg;
}

-(void)initView
{
    self.bgView.layer.shadowOffset = CGSizeMake(0, 1);
    self.bgView.layer.shadowOpacity = 0.10;
    self.bgView2.layer.shadowOffset = CGSizeMake(0, 1);
    self.bgView2.layer.shadowOpacity = 0.10;
    self.space1.backgroundColor = HMColor(234, 234, 234);
    self.space2.backgroundColor = HMColor(234, 234, 234);
    self.space3.backgroundColor = HMColor(234, 234, 234);
    self.space4.backgroundColor = HMColor(234, 234, 234);
    self.space5.backgroundColor = HMColor(234, 234, 234);
    self.space6.backgroundColor = HMColor(234, 234, 234);
    self.space7.backgroundColor = HMColor(234, 234, 234);
    self.space8.backgroundColor = HMColor(234, 234, 234);
    self.space9.backgroundColor = HMColor(234, 234, 234);

    
    NSArray *descriptions = @[@"2015-06-18 18:19:30 正在处理",@"2015-06-18 18:01:10 已分派",@"2015-06-18 16:19:30 订单确认",@"2015-06-18 15:11:10 下单成功"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:nil
                                                           andTimeDescriptionArray:descriptions
                                                                  andCurrentStatus:1
                                                                          andFrame:CGRectMake(-30, 50, self.view.width - 30, 100)];
    [self.bgView2 addSubview:timeline];
    
    self.bgView2.height = CGRectGetMaxY(timeline.frame) + 60;
    
    self.myScrollview.contentSize = CGSizeMake(0, CGRectGetMaxY(self.bgView2.frame));
}

@end
